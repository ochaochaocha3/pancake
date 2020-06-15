# frozen_string_literal: true

require_relative 'pancake_pb'
require_relative 'pancake_services_pb'

module Pancake
  class Baker < PancakeBakerService::Service
    class Report
      def initialize
        @mutex = Mutex.new
        @counts = {}
      end

      def inc(menu)
        @mutex.synchronize do
          @counts[menu] ||= 0
          @counts[menu] += 1
        end
      end

      def to_proto_obj
        bake_counts = @mutex.synchronize do
          @counts.map { |k, v|
            ::Pancake::Report::BakeCount.new(menu: k, count: v)
          }
        end

        ::Pancake::Report.new(bake_counts: bake_counts)
      end
    end

    def initialize(server)
      @server = server

      @report = Report.new
    end

    def bake(request, _call)
      if request.menu == :UNKNOWN
        raise GRPC::StatusError.new(
          GRPC::Status::INVALID_ARGUMENT,
          'パンケーキを選んでください'
        )
      end

      now = Time.now
      seconds = now.to_i
      nanos = ((now.to_f - seconds) * 1e9).to_i

      @report.inc(request.menu)

      BakeResponse.new(
        pancake: Pancake.new(
          menu: request.menu,
          chef_name: 'ocha',
          technical_score: rand(),
          create_time: Google::Protobuf::Timestamp.new(
            seconds: seconds,
            nanos: nanos
          )
        )
      )
    end

    def report(_request, _call)
      report_obj = @report.to_proto_obj
      ReportResponse.new(report: report_obj)
    end

    def stop(_request, _call)
      @server.stop
      StopResponse.new
    end
  end
end

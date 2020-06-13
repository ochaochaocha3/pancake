# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: pancake.proto for package 'pancake'

require 'grpc'
require 'pancake_pb'

module Pancake
  module PancakeBakerService
    class Service

      include GRPC::GenericService

      self.marshal_class_method = :encode
      self.unmarshal_class_method = :decode
      self.service_name = 'pancake.PancakeBakerService'

      # Bake は指定されたメニューのパンケーキを焼くメソッドです。
      # 焼かれたパンケーキをレスポンスとして返します。
      rpc :Bake, BakeRequest, BakeResponse
      # Report はメニューごとに焼いたパンケーキの数を返します。
      rpc :Report, ReportRequest, ReportResponse
    end

    Stub = Service.rpc_stub_class
  end
end
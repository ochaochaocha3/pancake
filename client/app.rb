# frozen_string_literal: true

lib_pancake_dir = File.expand_path('lib/pancake', __dir__)
$LOAD_PATH.unshift(lib_pancake_dir) unless $LOAD_PATH.include?(lib_pancake_dir)

require 'sinatra'
require 'sinatra/reloader' if development?

require 'pancake_pb'
require 'pancake_services_pb'

require 'common'
require 'bake_count'

stub = Pancake::PancakeBakerService::Stub.new(
  'localhost:50051',
  :this_channel_is_insecure,
  timeout: 5
)

get '/' do
  send_file(File.join(settings.public_folder, 'index.html'))
end

get '/report' do
  response = stub.report(Pancake::ReportRequest.new)

  bake_counts = response.report.bake_counts.map { |c|
    Pancake::BakeCount.from_proto_obj(c)
  }

  erb(:report, locals: {
    bake_counts: bake_counts,
  })
end

post '/pancake' do
  menu_s = params['menu']
  unless menu_s
    halt 400, 'no menu'
  end

  menu = Pancake::MENU_TO_PROTO_VALUE[menu_s]
  unless menu
    halt 400, "invalid menu: #{menu_s}"
  end

  request = Pancake::BakeRequest.new(menu: menu)
  response = stub.bake(request)

  erb(:baked, locals: {
    menu: Pancake::MENU_PROTO_VALUE_TO_STRING[response.pancake.menu] || 'Unknown',
    chef: response.pancake.chef_name,
    technical_score: response.pancake.technical_score,
    create_time: Time.at(response.pancake.create_time.seconds),
  })
end

post '/stop' do
  request = Pancake::StopRequest.new
  response = stub.stop(request)

  'Server has been shutdown!'
end

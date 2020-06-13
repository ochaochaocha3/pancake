.PHONY: proto_boilerplate

all: proto_boilerplate

proto_boilerplate: \
  api/gen/api/pancake.pb.go \
  api_ruby/lib/pancake/pancake_pb.rb \
  client/lib/pancake/pancake_pb.rb

api/gen/api/pancake.pb.go: proto/pancake.proto
	protoc -Iproto --go_out=plugins=grpc:api proto/*.proto

api_ruby/lib/pancake/pancake_pb.rb: proto/pancake.proto
	cd api_ruby && make proto_boilerplate

client/lib/pancake/pancake_pb.rb: proto/pancake.proto
	cd client && make proto_boilerplate

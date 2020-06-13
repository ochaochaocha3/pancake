.PHONY: proto_boilerplate

all: proto_boilerplate

proto_boilerplate: lib/pancake/pancake_pb.rb

lib/pancake/pancake_pb.rb: ../proto/pancake.proto
	bundle exec grpc_tools_ruby_protoc \
		-I ../proto \
		--ruby_out=lib/pancake \
		--grpc_out=lib/pancake \
		../proto/*.proto

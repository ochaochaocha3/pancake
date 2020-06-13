.PHONY: proto_boilerplate

all: proto_boilerplate

proto_boilerplate: api/gen/api/pancake.pb.go client/lib/pancake/pancake_pb.rb

api/gen/api/pancake.pb.go: proto/pancake.proto
	protoc -Iproto --go_out=plugins=grpc:api proto/*.proto

client/lib/pancake/pancake_pb.rb: proto/pancake.proto
	cd client && make proto_boilerplate

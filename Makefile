.PHONY: proto_boilerplate

all: proto_boilerplate

proto_boilerplate: api/gen/api/pancake.pb.go

api/gen/api/pancake.pb.go: proto/pancake.proto
	protoc -Iproto --go_out=plugins=grpc:api proto/*.proto

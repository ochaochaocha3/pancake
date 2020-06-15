package main

import (
	"fmt"
	"log"
	"net"
	"os"
	"os/signal"

	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"

	"github.com/ochaochaocha3/pancake/api/gen/api"
	"github.com/ochaochaocha3/pancake/api/handler"
)

// main はメイン処理の関数。
func main() {
	port := 50051

	lis, err := net.Listen("tcp", fmt.Sprintf(":%d", port))
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	server := grpc.NewServer()
	stopChan := make(chan bool)
	api.RegisterPancakeBakerServiceServer(
		server,
		handler.NewBakerHandler(server, stopChan),
	)
	reflection.Register(server)

	go func() {
		log.Printf("start gRPC server port: %v", port)
		server.Serve(lis)
	}()

	intChan := make(chan os.Signal)
	signal.Notify(intChan, os.Interrupt)

	select {
	case <-stopChan:
	case <-intChan:
	}

	log.Println("stopping gRPC server...")
	server.GracefulStop()
}

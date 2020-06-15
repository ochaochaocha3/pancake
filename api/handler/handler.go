package handler

import (
	"context"
	"math/rand"
	"sync"
	"time"

	"github.com/golang/protobuf/ptypes/timestamp"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/ochaochaocha3/pancake/api/gen/api"
)

func init() {
	rand.Seed(time.Now().UnixNano())
}

type BakerHandler struct {
	server   *grpc.Server
	stopChan chan bool
	report   *report
}

type report struct {
	sync.Mutex
	data map[api.Pancake_Menu]int
}

func NewBakerHandler(server *grpc.Server, stopChan chan bool) *BakerHandler {
	return &BakerHandler{
		server:   server,
		stopChan: stopChan,
		report: &report{
			data: map[api.Pancake_Menu]int{},
		},
	}
}

func (h *BakerHandler) Bake(
	ctx context.Context,
	req *api.BakeRequest,
) (*api.BakeResponse, error) {
	if req.Menu == api.Pancake_UNKNOWN || req.Menu > api.Pancake_SPICY_CURRY {
		return nil, status.Errorf(codes.InvalidArgument, "パンケーキを選んでください!")
	}

	now := time.Now()

	{
		h.report.Lock()

		h.report.data[req.Menu] += 1

		h.report.Unlock()
	}

	return &api.BakeResponse{
		Pancake: &api.Pancake{
			Menu:           req.Menu,
			ChefName:       "ocha",
			TechnicalScore: rand.Float32(),
			CreateTime: &timestamp.Timestamp{
				Seconds: now.Unix(),
				Nanos:   int32(now.Nanosecond()),
			},
		},
	}, nil
}

func (h *BakerHandler) Report(
	ctx context.Context,
	req *api.ReportRequest,
) (*api.ReportResponse, error) {
	var counts []*api.Report_BakeCount

	{
		h.report.Lock()

		for k, v := range h.report.data {
			counts = append(counts, &api.Report_BakeCount{
				Menu:  k,
				Count: int32(v),
			})
		}

		h.report.Unlock()
	}

	return &api.ReportResponse{
		Report: &api.Report{
			BakeCounts: counts,
		},
	}, nil
}

func (h *BakerHandler) Stop(
	ctx context.Context,
	req *api.StopRequest,
) (*api.StopResponse, error) {
	h.stopChan <- true
	return &api.StopResponse{}, nil
}

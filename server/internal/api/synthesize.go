package api

import (
	"context"

	synthesizeV1 "github.com/ouiasy/nicolivekit/server/gen/synthesize/v1"
	"github.com/ouiasy/nicolivekit/server/internal/service"
)

type SynthesizeHandler struct {
	es *service.EnqueueService
}

func NewSynthesizeHandler(es *service.EnqueueService) *SynthesizeHandler {
	return &SynthesizeHandler{es}
}

func (sh *SynthesizeHandler) Synthesize(
	ctx context.Context, request *synthesizeV1.SynthesizeRequest,
) (*synthesizeV1.SynthesizeResponse, error) {
	// channelにrequest.Messageの内容を送信する
	sh.es.Send(request.Message)
	res := synthesizeV1.SynthesizeResponse{Success: true, Message: request.Message + "hello"}
	return &res, nil
}

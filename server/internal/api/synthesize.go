package api

import (
	"context"

	synthesizeV1 "github.com/ouiasy/nicolivekit/server/gen/synthesize/v1"
)

func (s *AppState) Synthesize(
	ctx context.Context, request *synthesizeV1.SynthesizeRequest,
) (*synthesizeV1.SynthesizeResponse, error) {
	// channelにrequest.Messageの内容を送信する

	res := synthesizeV1.SynthesizeResponse{Success: true, Message: request.Message + "hello"}
	return &res, nil
}

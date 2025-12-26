package service

import "github.com/ouiasy/nicolivekit/server/internal/core"

type EnqueueService struct {
	e core.SynthesisEnqueuer
}

func NewEnqueueService(enqueuer core.SynthesisEnqueuer) *EnqueueService {
	return &EnqueueService{
		enqueuer,
	}
}

func (s *EnqueueService) Send(msg string) (string, error) {
	msgReq := core.NewSynthesisReq(msg)
	return s.e.Enqueue(msgReq)
}

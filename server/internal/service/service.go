package service

import "github.com/ouiasy/nicolivekit/server/internal/core"

type SpeechService struct {
	e core.SynthesisEnqueuer
}

func NewSpeechService(enqueuer core.SynthesisEnqueuer) *SpeechService {
	return &SpeechService{
		enqueuer,
	}
}

func (s *SpeechService) Send(msg string) (string, error) {
	msgReq := core.NewSynthesisReq(msg)
	return s.e.Enqueue(msgReq)
}

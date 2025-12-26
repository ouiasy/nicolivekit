package service

import (
	"context"

	"github.com/ouiasy/nicolivekit/server/internal/core"
)

type SynthesisService struct {
	synthesizer core.VoiceSynthesizer
}

func (s *SynthesisService) RunSynthesizer(ctx context.Context) {
	s.synthesizer.StartSynthesize(ctx)
}

func NewSynthesisService(s core.VoiceSynthesizer) *SynthesisService {
	return &SynthesisService{synthesizer: s}
}

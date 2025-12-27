package worker

import (
	"context"
	"log/slog"

	"github.com/ouiasy/nicolivekit/server/internal/service"
)

type SynthesisWorker struct {
	ss *service.SynthesisService
}

func NewSynthesisWorker(ss *service.SynthesisService) *SynthesisWorker {
	return &SynthesisWorker{
		ss,
	}
}

func (worker *SynthesisWorker) Run(ctx context.Context) {
	slog.Info("SynthesisWorker started waiting for tasks...")
	worker.ss.RunSynthesizer(ctx)
}

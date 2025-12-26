package worker

import (
	"context"

	"github.com/ouiasy/nicolivekit/server/internal/api"
	"github.com/ouiasy/nicolivekit/server/internal/core"
)

type SynthesisWorker struct {
	rx <-chan *core.SynthesisReq
}

func NewSynthesisWorker(stream <-chan *core.SynthesisReq) *SynthesisWorker {
	return &SynthesisWorker{
		rx: stream,
	}
}

func (worker *SynthesisWorker) Run(ctx context.Context, state api.AppState) {
	state.Logger.Info("SynthesisWorker started waiting for tasks...")
	for {
		select {
		case <-ctx.Done():
			state.Logger.Info("SynthesisWorker stopping...")
			return
		case req, ok := <-worker.rx:
			if !ok {
				continue
			}
			worker.process(req)
		}
	}
}

func (worker *SynthesisWorker) process(req *core.SynthesisReq) {

}

package app

import (
	"context"
	"fmt"
	"log/slog"
	"net/http"

	"connectrpc.com/connect"
	"connectrpc.com/validate"
	"github.com/go-chi/chi/v5"
	"github.com/ouiasy/nicolivekit/server/gen/synthesize/v1/synthesizev1connect"
	"github.com/ouiasy/nicolivekit/server/internal/adapter"
	"github.com/ouiasy/nicolivekit/server/internal/api"
	"github.com/ouiasy/nicolivekit/server/internal/config"
	"github.com/ouiasy/nicolivekit/server/internal/core"
	"github.com/ouiasy/nicolivekit/server/internal/service"
	"github.com/ouiasy/nicolivekit/server/internal/worker"
)

func Run(ctx context.Context) error {
	cfg, err := config.Load()
	if err != nil {
		return fmt.Errorf("error loading config yaml file")
	}

	logger := slog.Default()

	ch := make(chan *core.SynthesisReq, 10)

	// synthesizer
	defaultPlayer, err := adapter.NewDefaultPlayer()
	if err != nil {
		return err
	}
	vc := adapter.NewVoicepeakClient(ch, defaultPlayer, cfg.VoicePeak)
	ss := service.NewSynthesisService(vc)
	synthesisWorker := worker.NewSynthesisWorker(ss)
	go synthesisWorker.Run(ctx, logger)

	// enqueuer
	sq := adapter.NewSynthesisReqQueue(ch)
	es := service.NewEnqueueService(sq)
	synthesizeHandler := api.NewSynthesizeHandler(es)

	r := chi.NewRouter()

	path, handler := synthesizev1connect.NewSpeechServiceHandler(
		synthesizeHandler,
		connect.WithInterceptors(validate.NewInterceptor()),
	)
	r.Mount(path, handler)

	p := new(http.Protocols)
	p.SetHTTP1(true)
	// Use h2c so we can serve HTTP/2 without TLS.
	p.SetUnencryptedHTTP2(true)
	s := http.Server{
		Addr:      cfg.Api.Host + ":" + cfg.Api.Port,
		Handler:   r,
		Protocols: p,
	}
	// todo
	if err := s.ListenAndServe(); err != nil {
		return err
	}

	return nil
}

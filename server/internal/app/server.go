package app

import (
	"context"
	"errors"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

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
		slog.Error("error loading config yaml file")
		return err
	}

	ch := make(chan *core.SynthesisReq, 10)

	defaultPlayer, err := adapter.NewDefaultPlayer()
	if err != nil {
		slog.Error("error preparing player", "error", err)
		return err
	}
	vc := adapter.NewVoicepeakClient(ch, defaultPlayer, cfg.VoicePeak)
	ss := service.NewSynthesisService(vc)
	synthesisWorker := worker.NewSynthesisWorker(ss)

	workerCtx, workerCancel := context.WithCancel(ctx)
	defer workerCancel()
	go synthesisWorker.Run(workerCtx)

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
	go func() {
		slog.Info("listening...", "address", cfg.Api.Host+":"+cfg.Api.Port)
		if err := s.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
			slog.Error("error while executing server job", "error", err)
		}
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGTERM, syscall.SIGINT)
	<-quit

	ctx, cancel := context.WithTimeout(ctx, 30*time.Second)
	defer cancel()
	if err := s.Shutdown(ctx); err != nil {
		os.Exit(1)
	}

	return nil
}

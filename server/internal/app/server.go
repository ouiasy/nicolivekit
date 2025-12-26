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
	"github.com/ouiasy/nicolivekit/server/internal/api"
	"github.com/ouiasy/nicolivekit/server/internal/config"
)

func Run(ctx context.Context) error {
	cfg, err := config.Load()
	if err != nil {
		return fmt.Errorf("error loading config yaml file")
	}

	logger := slog.Default()
	state := api.NewAppState(logger, cfg)

	r := chi.NewRouter()

	path, handler := synthesizev1connect.NewSpeechServiceHandler(
		state,
		connect.WithInterceptors(validate.NewInterceptor()),
	)
	r.Mount(path, handler)

	p := new(http.Protocols)
	p.SetHTTP1(true)
	// Use h2c so we can serve HTTP/2 without TLS.
	p.SetUnencryptedHTTP2(true)
	s := http.Server{
		Addr:      "0.0.0.0:8080",
		Handler:   r,
		Protocols: p,
	}
	if err := s.ListenAndServe(); err != nil {
		return err
	}

	return nil
}

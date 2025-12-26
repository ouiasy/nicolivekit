package api

import (
	"log/slog"

	"github.com/ouiasy/nicolivekit/server/internal/config"
)

type AppState struct {
	Logger *slog.Logger
	Conf   *config.GlobalConfig
}

func NewAppState(l *slog.Logger, c *config.GlobalConfig) *AppState {
	return &AppState{
		Logger: l,
		Conf:   c,
	}
}

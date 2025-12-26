package adapter

import (
	"fmt"
	"os/exec"
	"runtime"

	"github.com/ouiasy/nicolivekit/server/internal/core"
)

type Player struct {
	cmdName string
}

func (p *Player) Play(path string) error {
	return exec.Command("afplay", path).Run()
}

func NewDefaultPlayer() (core.Player, error) {
	var cmdName string
	switch runtime.GOOS {
	case "darwin":
		cmdName = "afplay"
	case "linux":
		cmdName = "aplay"
	default:
		return nil, fmt.Errorf("unsupported platform: %s", runtime.GOOS)
	}

	_, err := exec.LookPath(cmdName)
	if err != nil {
		return nil, fmt.Errorf("error player %s not found", cmdName)
	}

	return &Player{cmdName}, nil
}

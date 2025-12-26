package adapter

import (
	"context"
	"fmt"
	"log/slog"
	"os/exec"
	"strings"

	"github.com/ouiasy/nicolivekit/server/internal/config"
	"github.com/ouiasy/nicolivekit/server/internal/core"
)

type VoicepeakClient struct {
	rx     <-chan *core.SynthesisReq
	player core.Player
	conf   *config.VoicePeakConf
}

func NewVoicepeakClient(
	rx <-chan *core.SynthesisReq,
	player core.Player,
	conf *config.VoicePeakConf,
) *VoicepeakClient {
	return &VoicepeakClient{
		rx,
		player,
		conf,
	}
}

func (vc *VoicepeakClient) StartSynthesize(ctx context.Context) {
	for {
		select {
		case <-ctx.Done():
			return
		case msg, ok := <-vc.rx:
			if !ok {
				slog.Info("Synthesis request channel closed")
				return
			}
			params := core.NewSynthesizeParams(msg)
			if err := execVoicepeakCmd(ctx, params, vc.conf); err != nil {
				slog.Error("error creating wav file: ", err)
				continue
			}
			if err := vc.player.Play(vc.conf.WavPath); err != nil {
				slog.Error("error while playing sound: ", err)
			}
		}
	}
}

func execVoicepeakCmd(ctx context.Context, params *core.SynthesizeParams, conf *config.VoicePeakConf) error {
	args := processVoicepeakArgs(params, conf.WavPath)

	err := exec.CommandContext(ctx, conf.BinPath, args...).Run()
	if err != nil {
		return fmt.Errorf("error executing voicepeak command: %w", err)
	}
	return nil
}

func processVoicepeakArgs(params *core.SynthesizeParams, wavOutputPath string) []string {
	var args []string
	var emotions []string

	emotions = append(
		emotions,
		fmt.Sprintf("bosoboso=%d", params.Emotions.Whisper),
		fmt.Sprintf("doyaru=%d", params.Emotions.Proud),
		fmt.Sprintf("honwaka=%d", params.Emotions.Warm),
		fmt.Sprintf("angry=%d", params.Emotions.Angry),
		fmt.Sprintf("teary=%d", params.Emotions.Sad),
	)

	emotionArgs := strings.Join(emotions, ",")

	args = append(args, "--say", params.Text, "--out", wavOutputPath)
	args = append(args, "--emotion", emotionArgs)

	return args
}

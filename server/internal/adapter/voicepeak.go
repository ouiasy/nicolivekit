package adapter

import (
	"context"
	"fmt"
	"log"
	"log/slog"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/google/uuid"
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
	if err := os.MkdirAll(conf.WavFolder, 0700); err != nil {
		log.Fatalf("failed to create tmp directory: %v", err)
	}
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
			filePath := filepath.Join(vc.conf.WavFolder, uuid.NewString()+".wav")
			if err := execVoicepeakCmd(ctx, params, vc.conf.BinPath, filePath); err != nil {
				slog.Error("error creating wav file: ", err)
				continue
			}
			go func() {
				err := vc.player.Play(filePath)
				if err != nil {
					slog.Error("error while playing sound: ", err)
				}
			}()
		}
	}
}

func execVoicepeakCmd(ctx context.Context, params *core.SynthesizeParams, binPath string, outputFilePath string) error {
	args := processVoicepeakArgs(params, outputFilePath)
	fmt.Println(args)

	err := exec.CommandContext(ctx, binPath, args...).Run()
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

	args = append(args, "--say", "..."+params.Text, "--out", wavOutputPath)
	args = append(args, "--emotion", emotionArgs)

	return args
}

package core

import "context"

type Player interface {
	Play(path string) error
}

type VoiceSynthesizer interface {
	StartSynthesize(ctx context.Context)
}

type SynthesizeParams struct {
	Text     string
	Speed    uint
	Pitch    int
	Emotions SentimentParams
}

type SentimentParams struct {
	Whisper uint
	Warm    uint
	Proud   uint
	Angry   uint
	Sad     uint
}

type SynthesizeOption func(*SynthesizeParams)

func NewSynthesizeParams(req *SynthesisReq, opts ...SynthesizeOption) *SynthesizeParams {
	p := &SynthesizeParams{
		Text:     req.Text,
		Speed:    120,
		Pitch:    100,
		Emotions: SentimentParams{},
	}

	for _, opt := range opts {
		opt(p)
	}
	return p
}

func WithEmotions(emotions SentimentParams) SynthesizeOption {
	return func(args *SynthesizeParams) {
		args.Emotions = emotions
	}
}

func WithPitch(p uint) SynthesizeOption {
	return func(args *SynthesizeParams) {
		args.Speed = p
	}
}

func NewSentimentParams(whisper, warm, proud, angry, sad uint) SentimentParams {

	return SentimentParams{
		Whisper: clamp(whisper),
		Warm:    clamp(warm),
		Proud:   clamp(proud),
		Angry:   clamp(angry),
		Sad:     clamp(sad),
	}
}

func clamp(val uint) uint {
	if val > 100 {
		return 100
	}
	return val
}

package core

type VoiceSynthesizer interface {
	Synthesize()
	Play() error
}

type SynthesizeParams struct {
	Text     string
	Pitch    uint
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

func NewSynthesizeParams(text string, opts ...SynthesizeOption) *SynthesizeParams {
	p := &SynthesizeParams{
		Text:     text,
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
		args.Pitch = p
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

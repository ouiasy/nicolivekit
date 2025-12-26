package core

type SynthesisEnqueuer interface {
	Enqueue(msg *SynthesisReq) (string, error)
}

type SynthesisReq struct {
	Text string
}

func NewSynthesisReq(text string) *SynthesisReq {
	return &SynthesisReq{
		Text: text,
	}
}

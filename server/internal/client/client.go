package client

import "github.com/ouiasy/nicolivekit/server/internal/core"

type SynthesisReqQueue struct {
	tx chan<- *core.SynthesisReq
}

func NewSynthesisReqQueue() *SynthesisReqQueue {
	return &SynthesisReqQueue{
		tx: make(chan *core.SynthesisReq),
	}
}

func (s *SynthesisReqQueue) Enqueue(msg *core.SynthesisReq) (string, error) {
	// todo: check channel blocking or other errors
	s.tx <- msg
	return msg.Text, nil
}

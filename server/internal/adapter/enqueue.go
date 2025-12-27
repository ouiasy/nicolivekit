package adapter

import (
	"fmt"

	"github.com/ouiasy/nicolivekit/server/internal/core"
)

type SynthesisReqQueue struct {
	tx chan<- *core.SynthesisReq
}

func NewSynthesisReqQueue(tx chan<- *core.SynthesisReq) *SynthesisReqQueue {
	return &SynthesisReqQueue{
		tx,
	}
}

func (s *SynthesisReqQueue) Enqueue(msg *core.SynthesisReq) (string, error) {
	// todo: check channel blocking or other errors
	select {
	case s.tx <- msg:
		return msg.Text, nil
	default:
		return "", fmt.Errorf("queue is full, try again later")
	}

}

package main

import (
	"context"
	"fmt"
	"net/http"

	"connectrpc.com/connect"
	"connectrpc.com/validate"
	"github.com/go-chi/chi/v5"
	synthesizeV1 "github.com/ouiasy/nicolivekit/server/gen/synthesize/v1"
	"github.com/ouiasy/nicolivekit/server/gen/synthesize/v1/synthesizev1connect"
)

type SynthesizeServer struct{}

func (s SynthesizeServer) Synthesize(
	ctx context.Context, request *synthesizeV1.SynthesizeRequest,
) (*synthesizeV1.SynthesizeResponse, error) {
	//TODO implement me
	fmt.Println("Synthesize called")
	fmt.Println("Message:", request.Message)

	res := synthesizeV1.SynthesizeResponse{Success: true, Message: request.Message + "hello"}
	return &res, nil
}

func main() {
	r := chi.NewRouter()
	synthesizer := &SynthesizeServer{}
	path, handler := synthesizev1connect.NewSpeechServiceHandler(
		synthesizer,
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
		panic(err)
	}
}

package main

import (
	"context"
	"log"

	"github.com/ouiasy/nicolivekit/server/internal/app"
)

func main() {
	ctx := context.Background()
	if err := app.Run(ctx); err != nil {
		log.Fatal(err)
	}

}

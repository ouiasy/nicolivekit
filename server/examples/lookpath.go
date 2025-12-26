package main

import (
	"fmt"
	"os/exec"
)

func main() {
	path, err := exec.LookPath("aplay")
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println(path)
}

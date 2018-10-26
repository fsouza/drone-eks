package main

import (
	"bytes"
	"fmt"
	"os/exec"

	"github.com/urfave/cli"
)

func awsAuth(c *cli.Context) error {
	var buf bytes.Buffer
	cmd := exec.Command("aws", "eks", "update-kubeconfig", "--name", c.String("cluster"))
	cmd.Stdout = &buf
	cmd.Stderr = &buf
	if err := cmd.Run(); err != nil {
		return fmt.Errorf("failed to authenticated with aws: %v\noutput: %s", err, &buf)
	}
	return nil
}

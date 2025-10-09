package env

import (
	"fmt"
	"os"

	"github.com/joho/godotenv"
)

var AdminPassword string
var AllowOrigin string

func init() {
	// Attempt to load .env file for local development.
	// In a production environment like Render, this file may not exist,
	// and that's okay. Environment variables will be loaded from the system.
	godotenv.Load()

	AdminPassword = os.Getenv("ADMIN_PASSWORD")
	AllowOrigin = os.Getenv("ALLOW_ORIGIN")
	if AllowOrigin == "" {
		AllowOrigin = "https://jiwooolee.github.io/wedding-inviation/"
	}
}

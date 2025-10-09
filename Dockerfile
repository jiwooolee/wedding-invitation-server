# Stage 1: Build the application
FROM golang:1.18-alpine AS builder

WORKDIR /app

# Copy go.mod and go.sum files to download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build the Go app
# CGO_ENABLED=0 is used to build a statically linked binary
# -o /app/main builds the executable in the /app directory with the name 'main'
RUN CGO_ENABLED=0 go build -o /app/main .

# Stage 2: Create the final, small image
FROM alpine:latest

WORKDIR /app

# Copy the built binary from the builder stage
COPY --from=builder /app/main .

# Expose port 8080 to the outside world
EXPOSE 8080

# Command to run the executable
# The server will be started when the container launches
CMD ["./main"]

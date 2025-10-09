# Stage 1: Build the application
FROM golang:1.18-alpine AS builder

# Install C compilers and SQLite development libraries needed for go-sqlite3
RUN apk add --no-cache build-base sqlite-dev

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Build the Go app with CGO enabled.
# This is necessary for go-sqlite3 to work.
RUN CGO_ENABLED=1 go build -o /app/main .

# Stage 2: Create the final, small image
FROM alpine:latest

# Install SQLite runtime libraries
RUN apk add --no-cache sqlite-libs

WORKDIR /app

# Copy the built binary from the builder stage
COPY --from=builder /app/main .

# Expose port 8080 to the outside world
EXPOSE 8080

# Command to run the executable
CMD ["./main"]
# Official base image for a Go project
FROM golang:1.22 as builder
LABEL authors="heatherss92065"

# Set the working directory inside the container
WORKDIR /app

# Copy the project files into the container
COPY translator ./

RUN CGO_ENABLED=0 GOOS=linux go build -v -o server ./cmd/server

FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/server .

# Run your application
CMD ["./server"]

# Official base image for a Rust project
FROM rust:latest as builder
LABEL authors="heatherss92065"

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the project files into the container
COPY palabras ./

# Build your application for release
RUN cargo build --release

# Use a minimal base image
FROM ubuntu:latest
WORKDIR /root/

# Install dependencies needed by the Rust application at runtime
RUN apt-get update && apt-get install -y libssl-dev libpq-dev

# Install CA certificates
RUN apt-get update && apt-get install -y ca-certificates

# Clean up
RUN rm -rf /var/lib/apt/lists/*

# Copy the compiled binary from the builder stage to the production image
COPY --from=builder /usr/src/app/target/release/palabras .

# Run your application
CMD ["./palabras"]

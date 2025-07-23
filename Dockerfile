# Base image
FROM debian:bullseye-slim

# Metadata
LABEL maintainer="Your Name <your.email@example.com>" \
      description="Network diagnostic container"

# Install necessary tools
RUN apt-get update && apt-get install -y \
    iputils-ping \
    curl \
    dnsutils \
    python3 \
    python3-pip \
    ca-certificates \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /opt/net-check

# Copy scripts into the container
COPY scripts/ ./scripts/
COPY scripts/run_all_checks.sh .

# Make sure all scripts are executable
RUN chmod +x run_all_checks.sh scripts/*.sh

# Default command
CMD ["./scripts/run_all_checks.sh"]

FROM python:3.11-slim

# Set up environment variables
ENV DATA_DIR=/data \
    PYTHONUNBUFFERED=1 \
    OLLAMA_HOST=0.0.0.0:11434 \
    OLLAMA_API_BASE_URL=http://localhost:11434/api \
    PATH="/root/.local/bin:${PATH}"

# Install system dependencies and clean up in a single layer
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    build-essential \
    ffmpeg \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/* \
    # Create required directories
    && mkdir -p /root/.local/bin \
    && mkdir -p /data/open-webui \
    && mkdir -p /data/wyoming-faster-whisper \
    # Install uv
    && curl -LsSf https://astral.sh/uv/install.sh | sh \
    # Install Ollama
    && curl -fsSL https://ollama.com/install.sh | sh

# Set up working directory
WORKDIR /app

# Install Python packages (specific version first, then others)
RUN uv pip install --system 'tokenizers>=0.21,<0.22' \
    && uv pip install --system -U open-webui wyoming-faster-whisper \
    && uv cache clean

# Copy startup script and make executable
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Expose ports (Open WebUI, wyoming-faster-whisper, Ollama)
EXPOSE 8080 8000 11434

# Start services
CMD ["/app/start.sh"]
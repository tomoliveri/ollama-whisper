FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    ffmpeg \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

# Install uv for Python package management
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Add uv to PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Set up working directory
WORKDIR /app

# Set up environment variables
ENV DATA_DIR=/data
ENV PYTHONUNBUFFERED=1

# Install Open WebUI
RUN uv pip install -U open-webui

# Install wyoming-faster-whisper
RUN uv pip install -U wyoming-faster-whisper

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Copy startup script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Create data directories
RUN mkdir -p /data/open-webui
RUN mkdir -p /data/wyoming-faster-whisper

# Expose ports
# 3000/8080: Open WebUI
# 10300: wyoming-faster-whisper
# 11434: Ollama
EXPOSE 3000 8080 10300 11434

# Start services
CMD ["/app/start.sh"]
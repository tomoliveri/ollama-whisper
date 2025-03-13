FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    ffmpeg \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

# Create .local/bin directory and add to PATH
RUN mkdir -p /root/.local/bin
ENV PATH="/root/.local/bin:${PATH}"

# Install uv for Python package management
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Set up working directory
WORKDIR /app

# Set up environment variables
ENV DATA_DIR=/data
ENV PYTHONUNBUFFERED=1
# Configure Ollama to bind to all interfaces
ENV OLLAMA_HOST=0.0.0.0:11434
# Configure Open WebUI to connect to Ollama using the internal container address
ENV OLLAMA_API_BASE_URL=http://localhost:11434/api

# Install Open WebUI
RUN uv pip install --system -U open-webui

# Install wyoming-faster-whisper
RUN uv pip install --system -U wyoming-faster-whisper

# Add transformers
RUN uv pip install transformers -U

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Copy startup script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Create data directories
RUN mkdir -p /data/open-webui
RUN mkdir -p /data/wyoming-faster-whisper

# Expose ports
# 8080: Open WebUI
# 8000: wyoming-faster-whisper (changed from 10300 to standard port)
# 11434: Ollama
EXPOSE 8080 8000 11434

# Start services
CMD ["/app/start.sh"]
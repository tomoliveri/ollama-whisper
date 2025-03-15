#!/bin/bash
set -e

# Reinstall Ollama to pick up GPU dependencies
echo "Reinstalling Ollama to enable GPU support..."
curl -fsSL https://ollama.com/install.sh | sh
echo "Ollama reinstalled."

# Reinstall Open WebUI
echo "Reinstalling Open WebUI..."
uv pip install --system -U open-webui
echo "Open WebUI reinstalled."

echo "Starting Ollama..."
nohup ollama serve > /var/log/ollama.log 2>&1 &
echo "Starting Wyoming Faster Whisper..."
# Explicitly bind to 0.0.0.0 instead of default localhost
nohup wyoming-faster-whisper \
--model base \
--data-dir /data/wyoming-faster-whisper \
--uri 'tcp://0.0.0.0:8000' > /var/log/whisper.log 2>&1 &
echo "Starting Open WebUI..."
# Use the correct command to start Open WebUI
DATA_DIR=/data/open-webui uvx --python 3.11 open-webui@latest serve
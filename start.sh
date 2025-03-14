#!/bin/bash
set -e

echo "Starting Ollama..."
nohup ollama serve > /var/log/ollama.log 2>&1 &

echo "Starting Wyoming Faster Whisper..."
# Explicitly bind to 0.0.0.0 instead of default localhost
nohup wyoming-faster-whisper \
  --model base \
  --data-dir /data/wyoming-faster-whisper \
  --uri 'tcp://0.0.0.0:8000' > /var/log/whisper.log 2>&1 &

echo "Starting Open WebUI..."
# Use python -m to run the module properly
python -m open_webui.main
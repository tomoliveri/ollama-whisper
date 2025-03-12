#!/bin/bash
set -e

# Start Ollama in the background
echo "Starting Ollama..."
ollama serve &

# Start wyoming-faster-whisper in the background
echo "Starting Wyoming Faster Whisper..."
python -m wyoming_faster_whisper \
  --model base \
  --language auto \
  --data-dir /data/wyoming-faster-whisper \
  --uri tcp://0.0.0.0:10300 &

# Wait a bit to ensure Ollama is running
sleep 5

# Start Open WebUI
echo "Starting Open WebUI..."
DATA_DIR=/data/open-webui open-webui serve

# Keep the container running
wait
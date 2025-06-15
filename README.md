# AI Suite Docker Image

This Docker image combines:

- Open WebUI v0.6.14
- Wyoming Faster Whisper v2.0.0
- Ollama vv0.9.0

## Ports

- 3000/8080: Open WebUI
- 10300: Wyoming Faster Whisper
- 11434: Ollama

## Usage

```bash
docker run -d \
  -p 3000:3000 \
  -p 10300:10300 \
  -p 11434:11434 \
  -v ollama-data:/root/.ollama \
  -v open-webui-data:/data/open-webui \
  -v whisper-data:/data/wyoming-faster-whisper \
  tomoliveri/ai-suite:latest
```

Last updated: 2025-06-15

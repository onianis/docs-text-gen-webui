#!/bin/bash

# Install nano (simply for convenience and access through the TrueNAS webUI iX App shell)
apt install nano

# Make sure newest python version is installed (it already seems to be installed - just for safety)
apt install python3.11-venv

# Create new virutal environment (cvenv == custom venv)
python3.11 -m venv /cvenv

# Another redundancy, but who knows what issues it might cause
/cvenv/bin/pip install --upgrade pip

# Install all the requirements for text-generation-webui itself
PIP_CACHE_DIR=/root/.cache/pip /cvenv/bin/python -m pip install --upgrade -r /root/.cache/pip/requirements.txt

# Install all requirements for the EdgeGPT extension (even though it doesn't seem to work right now)
#  (I have manually taken out the --extension flag from the start command due to currently unresolvable errors with EdgeGPT)
PIP_CACHE_DIR=/root/.cache/pip /cvenv/bin/python -m pip install --upgrade -r /app/extensions/EdgeGPT/requirements.txt

# Run the server script
exec /cvenv/bin/python /app/server.py --listen \
    --listen-host 0.0.0.0 \
    --listen-port 7860 \
    --model-dir /app/user_data/models/modularai_Llama-3.1-8B-Instruct-GGUF \
    --model llama-3.1-8b-instruct-q4_k_m.gguf \
    --loader llama.cpp \
    --gradio-auth-path /app/cutils/gradio-auth-set

# Deprecated start command without model loading
# exec /cvenv/bin/python /app/server.py --listen --listen-host 0.0.0.0 --listen-port 7860 --verbose --gradio-auth REDACTED:REDACTED

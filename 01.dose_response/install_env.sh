#!/bin/bash

uv venv oasis-prot-dr --python=python3.11
source oasis-prot-dr/bin/activate
uv pip install -r requirements.txt

echo "To activate later: source oasis-prot-dr/bin/activate"
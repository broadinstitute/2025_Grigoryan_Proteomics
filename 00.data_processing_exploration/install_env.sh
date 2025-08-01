#!/bin/bash

uv venv oasis-prot-proc --python=python3.11
source oasis-prot-proc/bin/activate
uv pip install -r requirements.txt

echo "To activate later: source oasis-prot-proc/bin/activate"
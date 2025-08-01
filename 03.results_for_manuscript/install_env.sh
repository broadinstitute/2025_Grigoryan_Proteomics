#!/bin/bash

uv venv oasis-prot-manu --python=python3.11
source oasis-prot-manu/bin/activate
uv pip install -r requirements.txt

echo "To activate later: source oasis-prot-manu/bin/activate"
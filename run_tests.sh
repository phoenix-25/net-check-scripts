#!/bin/bash
set -euo pipefail

echo "Making bash scripts executable..."
chmod +x scripts/*.sh

echo "Running shellcheck on bash scripts..."
if ! command -v shellcheck &> /dev/null; then
  echo "shellcheck not found, installing..."
  sudo apt-get update && sudo apt-get install -y shellcheck
fi
shellcheck scripts/*.sh

echo "Running bash script tests..."
# Esempio: ping_test.sh con 1 ping per test rapido
./scripts/ping_test.sh 8.8.8.8 1

echo "Installing Python dependencies if needed..."
if [ -f requirements.txt ]; then
  python3 -m pip install --upgrade pip
  python3 -m pip install -r requirements.txt
fi

echo "Running Python script tests..."
python3 scripts/tcp_latency_trace.py 8.8.8.8 80

echo "Running flake8 for Python linting..."
if ! command -v flake8 &> /dev/null; then
  echo "flake8 not found, installing..."
  python3 -m pip install flake8
fi
flake8 scripts/*.py

echo "All tests and linting passed!"

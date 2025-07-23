#!/bin/bash

# Ping test script to measure latency and jitter

TARGET=${1:-8.8.8.8}
COUNT=${2:-10}

echo "Pinging $TARGET $COUNT times..."

ping -c $COUNT $TARGET | tail -n 2

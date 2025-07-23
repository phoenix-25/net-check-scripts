#!/bin/bash

# Parametri
TARGET="${1:-8.8.8.8}"
COUNT="${2:-10}"

LOGFILE="../logs/ping_test_$(date +'%Y%m%d').log"
mkdir -p ../logs

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting ping test to $TARGET with $COUNT packets" | tee -a "$LOGFILE"

# Esegui il ping e cattura output e codice errore
PING_OUTPUT=$(ping -c "$COUNT" "$TARGET" 2>&1)
PING_EXIT_CODE=$?

if [ $PING_EXIT_CODE -ne 0 ]; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Ping to $TARGET failed." | tee -a "$LOGFILE"
  echo "Error details: $PING_OUTPUT" | tee -a "$LOGFILE"
  exit 1
else
  echo "$PING_OUTPUT" | tee -a "$LOGFILE"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Ping test completed successfully." | tee -a "$LOGFILE"
fi

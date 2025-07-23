#!/bin/bash

URL="${1:-https://www.google.com}"
LOGFILE="../logs/http_inspect_$(date +'%Y%m%d').log"
mkdir -p ../logs

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Inspecting HTTP headers for $URL" | tee -a "$LOGFILE"

HTTP_OUTPUT=$(curl -Is "$URL" 2>&1)
CURL_EXIT_CODE=$?

if [ $CURL_EXIT_CODE -ne 0 ]; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: curl failed to fetch headers from $URL" | tee -a "$LOGFILE"
  echo "Error details: $HTTP_OUTPUT" | tee -a "$LOGFILE"
  exit 1
else
  echo "$HTTP_OUTPUT" | tee -a "$LOGFILE"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] HTTP inspection completed successfully." | tee -a "$LOGFILE"
fi

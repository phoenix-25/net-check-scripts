#!/bin/bash

# =============================
# Network Diagnostics Launcher
# =============================

# === DEFAULT PARAMETERS ===

PING_TARGET="${1:-8.8.8.8}"
PING_COUNT="${2:-5}"
HTTP_URL="${3:-https://www.google.com}"
TCP_HOST="${4:-8.8.8.8}"
TCP_PORT="${5:-80}"

# === DIRECTORIES ===

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="$BASE_DIR/../logs"
REPORT_DIR="$BASE_DIR/../reports"

mkdir -p "$LOG_DIR" "$REPORT_DIR"

# === TIMESTAMPS & FILES ===

NOW=$(date +'%Y-%m-%d %H:%M:%S')
STAMP=$(date +'%Y%m%d_%H%M%S')
LOG_FILE="$LOG_DIR/run_all_checks_$STAMP.log"
TXT_REPORT="$REPORT_DIR/report_$STAMP.txt"
CSV_REPORT="$REPORT_DIR/report_$STAMP.csv"

# === LOGGING FUNCTION ===

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# === START ===

log "== Starting network diagnostics =="
log "Parameters:"
log "- Ping: $PING_TARGET ($PING_COUNT packets)"
log "- HTTP: $HTTP_URL"
log "- TCP: $TCP_HOST:$TCP_PORT"
echo

# === 1. PING TEST ===
log "--- Running ping_test.sh ---"
PING_OUTPUT=$(bash "$BASE_DIR/ping_test.sh" "$PING_TARGET" "$PING_COUNT" 2>&1)
if [ $? -ne 0 ]; then
  log "ERROR: ping_test.sh failed"
  log "$PING_OUTPUT"
  PING_AVG="ERROR"
else
  log "$PING_OUTPUT"
  PING_AVG=$(echo "$PING_OUTPUT" | grep -E 'rtt|round-trip' | awk -F'/' '{print $5}' | head -n1)
fi

# === 2. HTTP INSPECTION ===
log "--- Running http_inspect.sh ---"
HTTP_OUTPUT=$(bash "$BASE_DIR/http_inspect.sh" "$HTTP_URL" 2>&1)
if [ $? -ne 0 ]; then
  log "ERROR: http_inspect.sh failed"
  log "$HTTP_OUTPUT"
  HTTP_STATUS="ERROR"
else
  log "$HTTP_OUTPUT"
  HTTP_STATUS=$(echo "$HTTP_OUTPUT" | head -n 1 | awk '{print $2}')
fi

# === 3. TCP LATENCY TEST ===
log "--- Running tcp_latency_trace.py ---"
TCP_OUTPUT=$(python3 "$BASE_DIR/tcp_latency_trace.py" "$TCP_HOST" "$TCP_PORT" 2>&1)
if [ $? -ne 0 ]; then
  log "ERROR: tcp_latency_trace.py failed"
  log "$TCP_OUTPUT"
  TCP_SUMMARY="ERROR"
else
  log "$TCP_OUTPUT"
  TCP_SUMMARY=$(echo "$TCP_OUTPUT" | tail -n1)
fi

# === TEXT REPORT OUTPUT ===
log "--- Saving text report: $TXT_REPORT ---"
{
  echo "Network Check Report - $NOW"
  echo "=============================="
  echo
  echo "1) Ping Test to $PING_TARGET ($PING_COUNT packets)"
  echo "$PING_OUTPUT"
  echo
  echo "2) HTTP Inspection of $HTTP_URL"
  echo "$HTTP_OUTPUT"
  echo
  echo "3) TCP Latency Test to $TCP_HOST:$TCP_PORT"
  echo "$TCP_OUTPUT"
} > "$TXT_REPORT"

# === CSV REPORT OUTPUT ===
log "--- Saving CSV report: $CSV_REPORT ---"
{
  echo "timestamp;ping_target;ping_avg_ms;http_url;http_status;tcp_host;tcp_port;tcp_summary"
  echo "$STAMP;$PING_TARGET;$PING_AVG;$HTTP_URL;$HTTP_STATUS;$TCP_HOST;$TCP_PORT;\"$TCP_SUMMARY\""
} > "$CSV_REPORT"

# === END ===
log "== Diagnostics completed =="
log "Reports:"
log "- Text: $TXT_REPORT"
log "- CSV:  $CSV_REPORT"

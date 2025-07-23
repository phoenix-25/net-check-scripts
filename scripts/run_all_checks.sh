#!/bin/bash

# Directory report
REPORT_DIR="../reports"
mkdir -p "$REPORT_DIR"

# Timestamp per report
TIMESTAMP=$(date +'%Y%m%d_%H%M%S')

# Target di default (modifica qui se vuoi)
PING_TARGET="8.8.8.8"
PING_COUNT=5
HTTP_URL="https://www.google.com"
TCP_HOST="8.8.8.8"
TCP_PORT=80

# Permette di passare parametri opzionali in ordine: ping_target ping_count http_url tcp_host tcp_port
if [ ! -z "$1" ]; then PING_TARGET="$1"; fi
if [ ! -z "$2" ]; then PING_COUNT="$2"; fi
if [ ! -z "$3" ]; then HTTP_URL="$3"; fi
if [ ! -z "$4" ]; then TCP_HOST="$4"; fi
if [ ! -z "$5" ]; then TCP_PORT="$5"; fi

echo "Running network checks..."
echo "Ping target: $PING_TARGET ($PING_COUNT pings)"
echo "HTTP URL: $HTTP_URL"
echo "TCP host/port: $TCP_HOST:$TCP_PORT"
echo

# Funzione per eseguire uno script bash e catturare output
run_script() {
  local cmd=$1
  local output
  output=$(eval "$cmd" 2>&1)
  echo "$output"
}

# 1) Ping test
PING_RESULT=$(run_script "./ping_test.sh $PING_TARGET $PING_COUNT")

# Estrazione tempo medio ping da ping_test.sh (supponendo output tipo: rtt min/avg/max/mdev = 12.345/23.456/45.678/5.432 ms)
PING_AVG=$(echo "$PING_RESULT" | grep -E 'rtt|round-trip' | awk -F'/' '{print $5}' | head -n1)

# 2) HTTP inspect
HTTP_RESULT=$(run_script "./http_inspect.sh $HTTP_URL")

# Estrazione HTTP Status code (es. HTTP/1.1 200 OK)
HTTP_STATUS=$(echo "$HTTP_RESULT" | head -n1 | awk '{print $2}')

# 3) TCP latency trace (python)
TCP_RESULT=$(python3 ./tcp_latency_trace.py "$TCP_HOST" "$TCP_PORT")

# Per il CSV e testo estraiamo una linea significativa da TCP_RESULT, ad esempio l'ultima riga o la latenza media (dipende dal tuo script)
# Qui prendo l'ultima riga (modifica se serve)
TCP_SUMMARY=$(echo "$TCP_RESULT" | tail -n1)

# Creazione report testo
REPORT_TEXT="$REPORT_DIR/report_${TIMESTAMP}.txt"
{
  echo "Network Check Report - $TIMESTAMP"
  echo "---------------------------------"
  echo
  echo "Ping Test ($PING_TARGET, count=$PING_COUNT):"
  echo "$PING_RESULT"
  echo
  echo "HTTP Inspection ($HTTP_URL):"
  echo "$HTTP_RESULT"
  echo
  echo "TCP Latency Trace ($TCP_HOST:$TCP_PORT):"
  echo "$TCP_RESULT"
} > "$REPORT_TEXT"

echo "Text report saved to $REPORT_TEXT"

# Creazione report CSV
REPORT_CSV="$REPORT_DIR/report_${TIMESTAMP}.csv"
{
  echo "timestamp;ping_target;ping_avg_ms;http_url;http_status;tcp_host;tcp_port;tcp_summary"
  echo "$TIMESTAMP;$PING_TARGET;$PING_AVG;$HTTP_URL;$HTTP_STATUS;$TCP_HOST;$TCP_PORT;\"$TCP_SUMMARY\""
} > "$REPORT_CSV"

echo "CSV report saved to $REPORT_CSV"

echo
echo "Summary:"
echo "---------------------------------"
echo "Ping average latency (ms): $PING_AVG"
echo "HTTP Status code: $HTTP_STATUS"
echo "TCP summary: $TCP_SUMMARY"

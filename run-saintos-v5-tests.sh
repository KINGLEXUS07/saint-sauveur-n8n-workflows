#!/usr/bin/env bash
set -u

IDS=(
  saintos-v5-memory-rag
  saintos-v5-human-approval
  saintos-v5-monitoring
  saintos-v5-communication-manager
  saintos-v5-client-success-manager
  saintos-v5-research-manager
  saintos-v5-operations-manager
  saintos-v5-content-manager
  saintos-v5-voice-manager
  saintos-v5-command-center
)

LOG=/tmp/saintos-v5-test-results.log
: > "$LOG"

docker stop n8n >/dev/null
overall=0

for id in "${IDS[@]}"; do
  echo "=== TEST $id ===" | tee -a "$LOG"
  if docker run --rm --name "n8n-test-$id" --volumes-from n8n \
    -e N8N_ENCRYPTION_KEY=a137511203428a119b66493daa26e0756bbb9b46ba66d0b0fc09fe6419ee5c21 \
    -e N8N_SECURE_COOKIE=false \
    n8nio/n8n:latest execute --id="$id" >> "$LOG" 2>&1; then
    echo "PASS $id" | tee -a "$LOG"
  else
    echo "FAIL $id" | tee -a "$LOG"
    overall=1
  fi
done

docker start n8n >/dev/null
exit "$overall"

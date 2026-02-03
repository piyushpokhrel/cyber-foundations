#!/bin/bash
set -e

OUT="network_report.txt"

{
  echo "===== NETWORK BASELINE ====="
  date
  echo

  echo "===== HOSTNAME ====="
  hostname
  echo

  echo "===== INTERFACES (ip a) ====="
  ip a
  echo

  echo "===== ROUTING (ip route) ====="
  ip route
  echo

  echo "===== DNS (resolv.conf) ====="
  cat /etc/resolv.conf || true
  echo

  echo "===== LISTENING PORTS (ss) ====="
  ss -tulpen 2>/dev/null || ss -tuln || true
  echo

  echo "===== CONNECTIVITY ====="
  echo "[ping] 1.1.1.1"
  ping -c 2 1.1.1.1 || true
  echo

  echo "[dns] example.com"
  if command -v dig >/dev/null 2>&1; then
    dig +short example.com || true
  else
    getent hosts example.com || true
  fi
  echo

  echo "[http] https://example.com"
  if command -v curl >/dev/null 2>&1; then
    curl -I https://example.com --max-time 10 || true
  else
    echo "curl not installed"
  fi
  echo

  echo "[trace] to 1.1.1.1 (if traceroute exists)"
  if command -v traceroute >/dev/null 2>&1; then
    traceroute -m 10 1.1.1.1 || true
  else
    echo "traceroute not installed"
  fi
  echo

  echo "===== DONE ====="
} > "$OUT"

echo "Wrote $OUT"

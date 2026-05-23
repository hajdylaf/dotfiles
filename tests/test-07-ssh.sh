#!/usr/bin/env bash
errors=0
[ -f /home/testuser/.ssh/id_ed25519 ] || { echo "FAIL: SSH private key missing"; errors=$((errors+1)); }
[ -f /home/testuser/.ssh/id_ed25519.pub ] || { echo "FAIL: SSH public key missing"; errors=$((errors+1)); }
[ "$errors" -eq 0 ] || exit 1
echo "PASS"

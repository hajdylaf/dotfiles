#!/usr/bin/env bash
errors=0
# Use binary names, not package names
for cmd in zsh nvim bat fzf tmux ssh rsync; do
    command -v "$cmd" &>/dev/null || { echo "FAIL: $cmd not found"; errors=$((errors+1)); }
done
[ "$errors" -eq 0 ] || exit 1
echo "PASS"

#!/usr/bin/env bash
errors=0
for f in .zshrc .tmux.conf .gitconfig; do
    [ -f "/home/testuser/$f" ] || { echo "FAIL: $f not synced"; errors=$((errors+1)); }
done
for f in frm rmtrail update; do
    [ -x "/home/testuser/.local/bin/$f" ] || { echo "FAIL: $f not executable"; errors=$((errors+1)); }
done
[ "$errors" -eq 0 ] || exit 1
echo "PASS"

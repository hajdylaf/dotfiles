#!/usr/bin/env bash
errors=0
id testuser &>/dev/null || { echo "FAIL: user testuser does not exist"; errors=$((errors+1)); }
sudo -l -U testuser 2>&1 | grep -qE "\(ALL.*ALL\)" || { echo "FAIL: testuser cannot sudo"; errors=$((errors+1)); }
[ -f /etc/sudoers.d/99-dotfiles ] || { echo "FAIL: sudo drop-in missing"; errors=$((errors+1)); }
grep -q "^%wheel.*ALL=(ALL:ALL) ALL" /etc/sudoers.d/99-dotfiles || { echo "FAIL: sudo drop-in content wrong"; errors=$((errors+1)); }
[ "$errors" -eq 0 ] || exit 1
echo "PASS"

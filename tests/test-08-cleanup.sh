#!/usr/bin/env bash
[ ! -d /tmp/yay-build ] || { echo "FAIL: /tmp/yay-build was not cleaned up"; exit 1; }
echo "PASS"

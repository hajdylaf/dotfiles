#!/usr/bin/env bash
echo "=== Running dotfiles test suite ==="
echo

total=0
passed=0
failed=0

for test in "$(dirname "$0")"/test-*.sh; do
    name=$(basename "$test" .sh)
    total=$((total + 1))
    printf "  %s ... " "$name"
    if output=$(bash "$test" 2>&1); then
        echo "PASS"
        passed=$((passed + 1))
    else
        echo "FAIL"
        echo "       $output"
        failed=$((failed + 1))
    fi
done

echo
echo "=== Results: $passed/$total passed, $failed failed ==="
[ "$failed" -eq 0 ]

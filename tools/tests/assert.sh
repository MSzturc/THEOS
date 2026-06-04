#!/usr/bin/env bash
# Minimal assertion helpers for THEOS bash tests.
set -uo pipefail

TESTS_RUN=0
TESTS_FAILED=0

assert_equals() {
    local expected="$1" actual="$2" msg="${3:-}"
    TESTS_RUN=$((TESTS_RUN + 1))
    if [[ "$expected" == "$actual" ]]; then
        echo "PASS: ${msg}"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "FAIL: ${msg}"
        echo "  expected: [${expected}]"
        echo "  actual:   [${actual}]"
    fi
}

assert_contains() {
    local haystack="$1" needle="$2" msg="${3:-}"
    TESTS_RUN=$((TESTS_RUN + 1))
    if [[ "$haystack" == *"$needle"* ]]; then
        echo "PASS: ${msg}"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "FAIL: ${msg}"
        echo "  missing substring: [${needle}]"
    fi
}

assert_not_contains() {
    local haystack="$1" needle="$2" msg="${3:-}"
    TESTS_RUN=$((TESTS_RUN + 1))
    if [[ "$haystack" != *"$needle"* ]]; then
        echo "PASS: ${msg}"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "FAIL: ${msg}"
        echo "  unexpected substring present: [${needle}]"
    fi
}

assert_gt() {
    local actual="$1" threshold="$2" msg="${3:-}"
    TESTS_RUN=$((TESTS_RUN + 1))
    if [[ "$actual" -gt "$threshold" ]]; then
        echo "PASS: ${msg}"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "FAIL: ${msg}"
        echo "  expected ${actual} > ${threshold}"
    fi
}

finish_tests() {
    echo "----"
    echo "ran ${TESTS_RUN}, failed ${TESTS_FAILED}"
    [[ "${TESTS_FAILED}" -eq 0 ]]
}

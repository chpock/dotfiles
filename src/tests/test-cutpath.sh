#!/bin/bash

_cut_path() {
    local max trunc_label='...' path="$1"
    if [ -z "$COLUMNS" ] || ! max=$(( COLUMNS / 6 )) || [ $max -le 0 ]; then
        max=20
    fi
    if [ "$path" = "$HOME" ]; then
        path="~"
    elif [ "${path:0:$(( ${#HOME} + 1 ))}" = "${HOME}/" ]; then
        path="~${path:${#HOME}}"
    fi
    if [ "${#path}" -gt $max ]; then
        path="${trunc_label}${path:$(( ${#path} - $max + ${#trunc_label} ))}"
    fi
    echo "$path"
}

while IFS=' ' read -r test expected; do
    result="$(COLUMNS="" HOME=/home/test _cut_path "$test")"
    if [ "$result" = "$expected" ]; then
        echo "OK: $test -> $expected"
    else
        echo "FAIL: $test (result: '$result'; expected: '$expected')"
    fi
done <<'EOF'
/home/te                  /home/te
/home/test                 ~
/home/testt                /home/testt
/home/test/                ~/
/home/test/foo             ~/foo
/some/dir/1234567890       /some/dir/1234567890
/some/dir/12345678901      ...e/dir/12345678901
EOF

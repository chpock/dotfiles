#!/bin/bash

(return 0 2>/dev/null) || { echo "Error: this script must be sourced."; exit 1; }

test_vercomp() {
    local r="" f exp
    for f in le lt ge gt; do
        [ -z "$r" ] || r="$r "
        _vercomp "$1" $f "$3"
        r="$r${f}:$?"
    done
    case $2 in
        "=") exp="le:0 lt:1 ge:0 gt:1";;
        ">") [ -z "$4" ] && exp="le:1 lt:1 ge:0 gt:0" || exp="le:0 lt:0 ge:1 gt:1";;
        "<") [ -z "$4" ] && exp="le:0 lt:0 ge:1 gt:1" || exp="le:1 lt:1 ge:0 gt:0";;
    esac
    [ "$r" = "$exp" ] && echo "OK $1 and $3 ($exp)" || echo "FAIL: $1 and $3 (expected: $exp; result: $r)"
}

test_vercomp_smart() {
    case "$2" in
        "=")
            test_vercomp "$1" "=" "$3"
            test_vercomp "$3" "=" "$1"
            ;;
        ">")
            test_vercomp "$1" ">" "$3"
            test_vercomp "$3" "<" "$1"
            test_vercomp "$1" "<" "$3" "1"
            test_vercomp "$3" ">" "$1" "1"
            ;;
        "<")
            test_vercomp "$1" "<" "$3"
            test_vercomp "$3" ">" "$1"
            test_vercomp "$1" ">" "$3" "1"
            test_vercomp "$3" "<" "$1" "1"
            ;;
    esac
}

while read -r test; do
    test_vercomp_smart $test
done << EOF
1            = 1
1.0          = 1
1.0.0        = 1
1.000.00     = 1
1.009.09     = 1.9.9
1.01.1       = 1.1.1
1.0.1.0      = 1.0.1
1..2         = 1.0.2
1..0         = 1
3.0003       = 3.3
0005         = 5
08.09        = 8.9
1.1          > 1
1.0.1        > 1
1.0.0.1      > 1
1.000.00.1   > 1
1.009.09     > 1.9.8
1.2.3.10     > 1.2.3.1
1.2.30.1     > 1.2.3.1
1.02.01      > 1.02
3.0003.1     > 3.002
44.4         > 4.4.4
12345        > 1234
12345        > 1234.6
2.25.1       > 1.7.9
EOF


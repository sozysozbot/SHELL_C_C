#!/bin/bash
assert() {
  expected="$1"
  input="$2"

  ./compiler.sh "$input" > tmp.s
  cc -o tmp tmp.s
  ./tmp
  actual="$?"

  if [ "$actual" = "$expected" ]; then
    echo "$input => $actual"
  else
    echo "$input => $expected expected, but got $actual"
    exit 1
  fi
}

assert 0 0
assert 42 42
assert 21 "5+20-4"
assert 2 "5 - 3"
assert 6 "5 + 3-2"
assert 6 "5+ 3-2"
assert 6 "5 +3-2"

echo OK

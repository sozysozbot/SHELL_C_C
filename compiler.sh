#!/bin/bash
echoerr() { echo "$@" 1>&2; }

echo '.intel_syntax noprefix'
echo '.globl main'
echo ''
echo 'main:'
echo '        mov rax, 0'

foo=$1
num_buffer=''
previous_mnemonics='add'
for (( i=0; i<${#foo}; i++ )); do
  char="${foo:$i:1}"
  if [[ "$char" = '0' || "$char" = '1' || "$char" = '2' || "$char" = '3' || "$char" = '4' || "$char" = '5' || "$char" = '6' || "$char" = '7' || "$char" = '8' || "$char" = '9' ]]
  then
    echoerr "detected a number '$char'"
    num_buffer+=$char 
  elif [[ "$char" = '+' ]]
  then
    echo "        $previous_mnemonics rax, $num_buffer"
    tokens+=($num_buffer +)
    previous_mnemonics='add'
    num_buffer=''
    echoerr "detected an addition operator"
  elif [[ "$char" = '-' ]]
  then
    echo "        $previous_mnemonics rax, $num_buffer"
    tokens+=($num_buffer -)
    previous_mnemonics='sub'
    num_buffer=''
    echoerr "detected a subtraction operator"
  else
    echoerr "detected an unknown character '$char'"
  fi
done

echo "        $previous_mnemonics rax, $num_buffer"
echo '        ret'
tokens+=($num_buffer)
echoerr ${tokens[@]}

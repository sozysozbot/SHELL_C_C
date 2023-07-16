#!/bin/bash
echoerr() { echo "$@" 1>&2; }

input=$1
num_buffer=''
for (( i=0; i<${#input}; i++ )); do
  char="${input:$i:1}"
  if [[ "$char" = '0' || "$char" = '1' || "$char" = '2' || "$char" = '3' || "$char" = '4' || "$char" = '5' || "$char" = '6' || "$char" = '7' || "$char" = '8' || "$char" = '9' ]]
  then
    num_buffer+=$char 
  elif [[ "$char" = '+' ]]
  then
    tokens+=($num_buffer +)
    num_buffer=''
  elif [[ "$char" = '-' ]]
  then
    tokens+=($num_buffer -)
    num_buffer=''
  else
    echoerr "detected an unknown character '$char'"
  fi
done

tokens+=($num_buffer)

# tokenization is complete
# echoerr ${tokens[@]}

echo '.intel_syntax noprefix'
echo '.globl main'
echo ''
echo 'main:'
echo '        mov rax, 0'

num_buffer=''
previous_mnemonics='add'

for tok in "${tokens[@]}"
do
  if [[ "$tok" = '+' ]]
  then 
    echo "        $previous_mnemonics rax, $num_buffer"
    previous_mnemonics='add'
    num_buffer=''
  elif [[ "$tok" = '-' ]]
  then
    echo "        $previous_mnemonics rax, $num_buffer"
    previous_mnemonics='sub'
    num_buffer=''
  else
    num_buffer=$tok
  fi
done

echo "        $previous_mnemonics rax, $num_buffer"
echo '        ret'

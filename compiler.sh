#!/bin/bash
echoerr() { echo "$@" 1>&2; }

input=$1
buffer=''
for (( i=0; i<${#input}; i++ )); do
  char="${input:$i:1}"
  if [[ "$char" = '0' || "$char" = '1' || "$char" = '2' || "$char" = '3' || "$char" = '4' || "$char" = '5' || "$char" = '6' || "$char" = '7' || "$char" = '8' || "$char" = '9' ]]
  then
    buffer+=$char 
  elif [[ "$char" = '+' ]]
  then
    tokens+=($buffer +)
    buffer=''
  elif [[ "$char" = '-' ]]
  then
    tokens+=($buffer -)
    buffer=''
  elif [[ "$char" = ' ' ]]
  then
    tokens+=($buffer)
    buffer=''
  else
    echoerr "detected an unknown character '$char'"
  fi
done

tokens+=($buffer)

# tokenization is complete
# echoerr tokenization: ${tokens[@]}

echo '.intel_syntax noprefix'
echo '.globl main'
echo ''
echo 'main:'
echo '        mov rax, 0'

previous_num=''
previous_mnemonics='add'

for tok in "${tokens[@]}"
do
  if [[ "$tok" = '+' ]]
  then 
    echo "        $previous_mnemonics rax, $previous_num"
    previous_mnemonics='add'
    previous_num=''
  elif [[ "$tok" = '-' ]]
  then
    echo "        $previous_mnemonics rax, $previous_num"
    previous_mnemonics='sub'
    previous_num=''
  else
    previous_num=$tok
  fi
done

echo "        $previous_mnemonics rax, $previous_num"
echo '        ret'

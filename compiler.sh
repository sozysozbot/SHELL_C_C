#!/bin/bash
echo '.intel_syntax noprefix'
echo '.globl main'
echo ''
echo 'main:'
echo "        mov rax, $1"
echo '        ret'
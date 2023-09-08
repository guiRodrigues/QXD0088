#!/bin/bash

cut -d ' ' -f 2 compras.txt | tr '\n' '+' | total=$(echo "scale=2; 0$(cat)" | bc -l)

echo "O prejuízo é de R$ $total"

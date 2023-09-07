#!/bin/bash

total=$(awk '{soma+=$2} END {print soma}' products.txt)

echo "O prejuízo é de R$ $total"

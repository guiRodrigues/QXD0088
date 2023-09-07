#!/bin/bash

user=$(whoami)
current_datetime="Hoje é $(date +'%Y-%m-%d %H:%M:%S')"
# current_datetime="Hoje é dia $(date +'%d'), do mês $(date +'%m') do ano de $(date +'%Y')."

message="Olá $user, $current_datetime"

echo "$message" | cowsay
echo "$message" >> scripts/salutation.log

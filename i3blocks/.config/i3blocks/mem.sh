#/usr/bin/env bash

free -m | awk 'NR==2{printf "U:"; printf "%.1fG", $3/1024; printf " "; printf "A:"; printf "%.1fG", $7/1024; printf " " }'
free -m | awk 'NR==3{printf "S:"; printf "%.1fG", $3/1024;}'



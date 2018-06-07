#!/bin/bash
while IFS='' read -r line || [[ -n "$line" ]]; do
    echo "worker approve --hit $line"
done < "$1"

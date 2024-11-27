#!/bin/bash

file="$@"

wal -i "$file" -n
feh --bg-fill "$(< "${HOME}/.cache/wal/wal")"

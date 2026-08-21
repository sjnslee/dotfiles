#!/bin/sh
# Cross-platform battery % for the tmux status line. Prints "AC" on desktops.
if [ "$(uname)" = "Darwin" ]; then
  pmset -g batt | grep -oE '[0-9]+%' | head -1
else
  for bat in /sys/class/power_supply/BAT*/capacity; do
    if [ -r "$bat" ]; then
      echo "$(cat "$bat")%"
      exit 0
    fi
  done
  echo "AC"
fi

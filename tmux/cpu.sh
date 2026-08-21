#!/bin/sh
# Cross-platform CPU usage % for the tmux status line.
if [ "$(uname)" = "Darwin" ]; then
  # macOS: 3rd field of "CPU usage" line is the user %
  top -l 1 | awk '/CPU usage/ {print $3}'
else
  # Linux: 100 - idle% from the "%Cpu(s)" line of a single top sample
  idle=$(top -bn1 2>/dev/null | grep -m1 -oE '[0-9.]+ id' | grep -oE '^[0-9.]+')
  if [ -n "$idle" ]; then
    awk -v i="$idle" 'BEGIN { printf "%.0f%%\n", 100 - i }'
  else
    echo "n/a"
  fi
fi

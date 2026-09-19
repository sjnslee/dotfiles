#!/bin/sh
# Cross-platform CPU usage % for the tmux status line.
if [ "$(uname)" = "Darwin" ]; then
  # macOS: first top sample is skewed, so take the second one. busy = 100 - idle
  top -l 2 -n 0 -s 1 | awk '/CPU usage/ {idle = $7} END {printf "%.0f%%\n", 100 - idle}'
else
  # Linux: 100 - idle% from the "%Cpu(s)" line of a single top sample
  idle=$(top -bn1 2>/dev/null | grep -m1 -oE '[0-9.]+ id' | grep -oE '^[0-9.]+')
  if [ -n "$idle" ]; then
    awk -v i="$idle" 'BEGIN { printf "%.0f%%\n", 100 - i }'
  else
    echo "n/a"
  fi
fi

#!/bin/bash

PID_FILE="/tmp/ssm-session.pid"
LOG_FILE="$HOME/.ssm_status.log"

# Function to log messages
log_message() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Function to update sketchybar status
update_sketchybar() {
  sketchybar --set ssm_access icon="$1" icon.color="$2" label="SSM"
  log_message "Updated sketchybar icon to $1 with color $2"
}

log_message "Status check running"

# Check if the SSM session is running using pgrep
if pgrep -f "ssm.*session" > /dev/null 2>&1; then
  # SSM is running, get the actual PID
  ACTUAL_PID=$(pgrep -f "ssm.*session" | head -1)
  log_message "Found SSM process with PID $ACTUAL_PID"

  # Update the PID file
  echo "$ACTUAL_PID" > "$PID_FILE"

  # Update sketchybar to show active status
  update_sketchybar "🔒" "0xff4daf2b"
else
  # No SSM process found
  log_message "No SSM process found"

  # Clean up PID file if it exists
  if [ -f "$PID_FILE" ]; then
    log_message "Removing stale PID file"
    rm -f "$PID_FILE"
  fi

  # Update sketchybar to show inactive status
  update_sketchybar "🔓" "0xffff0000"
fi

#!/bin/bash

PID_FILE="/tmp/ssm-session.pid"
SSM_SCRIPT_PATH="$HOME/ssm-access.sh"  # Update this path
LOG_FILE="$HOME/.ssm_toggle.log"

# Function to log messages
log_message() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log_message "Toggle script executed"

# Check if an SSM session is already running
if pgrep -f "ssm.*session" > /dev/null 2>&1; then
  log_message "Found running SSM session, stopping it"

  SSM_PIDS=$(pgrep -f "ssm.*session")
  log_message "SSM PIDs: $SSM_PIDS"

  for pid in $SSM_PIDS; do
    log_message "Killing PID $pid"
    kill -9 "$pid" 2>/dev/null
  done

  for pid in $(pgrep -f "/opt/homebrew/bin/aws ssm start-session"); do
    log_message "Killing stale SSM session PID $pid"
    kill "$pid" 2>/dev/null
  done

  lsof -i :3306 | grep session-m | awk '{print $2}' | sort -u | xargs kill

  [ -f "$PID_FILE" ] && rm -f "$PID_FILE"

  sketchybar --trigger ssm_status_change

  log_message "SSM session stopped"
else
  log_message "Starting new SSM session"

  # Delay start using a function
  start_ssm_session() {
    echo 1 | "$SSM_SCRIPT_PATH" | while IFS= read -r line; do
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] $line" >> "$LOG_FILE"

      if [[ "$line" == *"Waiting for connections..."* ]]; then
        log_message "Detected 'Waiting for connections...', triggering sketchybar"

        ACTUAL_PID=$(pgrep -f "ssm.*session" | head -1)
        echo "$ACTUAL_PID" > "$PID_FILE"

        sketchybar --trigger ssm_status_change
      elif [[ "$line" == *"bind: address already in use"* ]]; then
        log_message "Port is already in use – session likely running, triggering sketchybar"

        # Also trigger sketchybar even though we're not starting a new session
        sketchybar --trigger ssm_status_change

        # Optionally break out of the loop to stop reading further
        break
      fi
    done
  }

  start_ssm_session &

  log_message "SSM session start initiated"
fi

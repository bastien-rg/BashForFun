# CUSTOM load/unload env variables
envctl() {
  local ENVS_DIR="$HOME/.envs"
  # Variables to unload (hardcoded)
  local VARS=(AWS_REGION AWS_ACCOUNT_ID AWS_PROFILE)

  case "${1:-guide}" in

    load)
      : "${2:?Usage: envctl load <name>}"
      local file="$ENVS_DIR/$2.env"
      : "${file:?}"
      if [[ ! -f "$file" ]]; then
        echo "Error: '$file' not found. Run: envctl list"
        return 1
      fi
      source "$file"
      echo "✓ Loaded $2"

      echo ""
      echo "Current state:"
      for var in "${VARS[@]}"; do
        printf '  %-20s = %s\n' "$var" "${!var:-"(not set)"}"
      done
      ;;

    unload)
      unset "${VARS[@]}"
      echo "✓ Unloaded: ${VARS[*]}"
      ;;

    list)
      echo "Available envs in $ENVS_DIR:"
      for f in "$ENVS_DIR"/*.env; do
        [[ -f "$f" ]] && echo "  - $(basename "$f" .env)"
      done
      echo ""
      echo "Current state:"
      for var in "${VARS[@]}"; do
        printf '  %-20s = %s\n' "$var" "${!var:-"(not set)"}"
      done
      ;;

    guide)
      cat <<EOF

  envctl — environment variable manager
  ══════════════════════════════════════

  Env files live in: $ENVS_DIR/<name>.env
  Each file should contain lines like:
    export AWS_REGION=us-east-1
    export AWS_ACCOUNT_ID=123456789012

  Commands:
    envctl load <name>   Load variables from ~/.envs/<name>.env
    envctl unload        Unset all managed variables
    envctl list          List available .env files and current state
    envctl guide         Show this message

  Managed variables (unloaded by 'envctl unload'):
$(printf '    - %s\n' "${VARS[@]}")
EOF
      ;;

    *)
      echo "Unknown command: $1"
      echo "Run: envctl guide"
      return 1
      ;;

  esac
}


# CUSTOM start ssh-agent
if [ -n "$SSH_AGENT_PID" ] && ps -p "$SSH_AGENT_PID" > /dev/null; then
   echo "ssh-agent is running (PID: $SSH_AGENT_PID)"
else
   echo "ssh-agent is not running, starting new ssh-agent"
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/bastien-ix
fi

# Add custom scripts to PATH
export PATH="$HOME/Development/scripts:$PATH"

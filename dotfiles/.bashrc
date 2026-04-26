# CUSTOM load/unload env variables
envload() { source ~/.envs/"$1".env && echo "Loaded $1"; }
envunload() { unset AWS_REGION AWS_ACCOUNT_ID && echo "Unloaded"; }
export PATH="$HOME/Development/scripts:$PATH"

# CUSTOM start ssh-agent
if [ -n "$SSH_AGENT_PID" ] && ps -p "$SSH_AGENT_PID" > /dev/null; then
   echo "ssh-agent is running (PID: $SSH_AGENT_PID)"
else
   echo "ssh-agent is not running, starting new ssh-agent"
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/bastien-ix
fi

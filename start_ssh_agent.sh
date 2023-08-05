function start_ssh_agent() {
  # Check for running ssh-agent
  SSH_AGENT_PIDS=$(pgrep -u "$USER" ssh-agent)

  if [ -z "$SSH_AGENT_PIDS" ]; then
    # if there is no running ssh-agent, start it
    eval $(ssh-agent -s)
    echo $SSH_AGENT_PID > $HOME/.ssh-agent
  else
    # ssh-agent is running, just set SSH_AGENT_PID to first pid in list
    SSH_AGENT_PID=${SSH_AGENT_PIDS%% *}
    echo $SSH_AGENT_PID > $HOME/.ssh-agent
    
    # Set SSH_AUTH_SOCK so that ssh-add can connect to the ssh-agent
    export SSH_AUTH_SOCK=$(find /tmp -path '*/ssh-*' -name 'agent.*' -user $(whoami) 2>/dev/null | head -1 2>/dev/null)
  fi

  # Add your SSH private key to the ssh-agent
  ssh-add ~/.ssh/id_rsa
}

start_ssh_agent > /dev/null 2>&1
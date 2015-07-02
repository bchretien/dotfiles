#!/usr/bin/env sh

if ([ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]) && [ -f ~/.tmux/status_ssh.tmux ]; then
  source ~/.tmux/status_ssh.tmux
elif [ -f ~/.tmux/status.tmux ]; then
  source ~/.tmux/status.tmux
fi

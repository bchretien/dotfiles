#!/usr/bin/env sh

if ([ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]) && [ -f ~/.tmux/status_ssh.tmux ]; then
  tmux source-file ~/.tmux/status_ssh.tmux >/dev/null 2>&1
elif [ -f ~/.tmux/status.tmux ]; then
  tmux source-file ~/.tmux/status.tmux >/dev/null 2>&1
fi

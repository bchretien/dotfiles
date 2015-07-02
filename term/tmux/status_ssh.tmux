# This tmux statusbar config was created by tmuxline.vim
# on Fri, 15 Aug 2014

tmux set -q status-bg "colour88"
tmux set -q message-command-fg "colour232"
tmux set -q status-justify "left"
tmux set -q status-left-length "100"
tmux set -q status "on"
tmux set -q pane-active-border-fg "colour88"
tmux set -q message-bg "colour244"
tmux set -q status-right-length "100"
tmux set -q status-right-attr "none"
tmux set -q message-fg "colour232"
tmux set -q message-command-bg "colour244"
tmux set -q status-attr "none"
tmux set -q status-utf8 "on"
tmux set -q pane-border-fg "colour244"
tmux set -q status-left-attr "none"
tmux setw -q window-status-fg "colour253"
tmux setw -q window-status-attr "bold"
tmux setw -q window-status-activity-bg "colour88"
tmux setw -q window-status-activity-attr "none"
tmux setw -q window-status-activity-fg "colour253"
tmux setw -q window-status-separator ""
tmux setw -q window-status-bg "colour88"
tmux set -q status-left "#[fg=colour253,bg=colour88,bold] #S "
tmux setw -q window-status-format "#[fg=colour253,bg=colour88,bold] #I #[fg=colour253,bg=colour88,bold] #W "
tmux setw -q window-status-current-format "#[fg=colour88,bg=colour178,nobold,nounderscore,noitalics]#[fg=colour232,bg=colour178] #I #[fg=colour232,bg=colour178] #W #[fg=colour178,bg=colour88,nobold,nounderscore,noitalics]"
tmux set -q status-right "#[fg=colour88,bg=colour88,nobold,nounderscore,noitalics]#[fg=colour253,bg=colour88,bold] %d/%m/%Y  %H:%M #[fg=colour88,bg=colour88,nobold,nounderscore,noitalics]#[fg=colour253,bg=colour88,bold] #h "

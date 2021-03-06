#!/usr/bin/env bash

is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

can_go_up="if [ \$(tmux display-message -p '#{pane_at_top}') -ne 1 ]; then exit 0; fi; exit 1"
can_go_down="if [ \$(tmux display-message -p '#{pane_at_bottom}') -ne 1 ]; then exit 0; fi; exit 1"
can_go_left="if [ \$(tmux display-message -p '#{pane_at_left}') -ne 1 ]; then exit 0; fi; exit 1"
can_go_right="if [ \$(tmux display-message -p '#{pane_at_right}') -ne 1 ]; then exit 0; fi; exit 1"

tmux bind-key -n C-h if-shell "$is_vim" "send-keys C-h"  "if-shell \"$can_go_left\" 'select-pane -L'"
tmux bind-key -n C-j if-shell "$is_vim" "send-keys C-j"  "if-shell \"$can_go_down\" 'select-pane -D'"
tmux bind-key -n C-k if-shell "$is_vim" "send-keys C-k"  "if-shell \"$can_go_up\" 'select-pane -U'"
tmux bind-key -n C-l if-shell "$is_vim" "send-keys C-l"  "if-shell \"$can_go_right\" 'select-pane -R'"
tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

tmux bind-key -T copy-mode-vi C-h select-pane -L
tmux bind-key -T copy-mode-vi C-j select-pane -D
tmux bind-key -T copy-mode-vi C-k select-pane -U
tmux bind-key -T copy-mode-vi C-l select-pane -R
tmux bind-key -T copy-mode-vi C-\\ select-pane -l

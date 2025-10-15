 #!/usr/bin/env bash
SESSION="monitor"

if tmux has-session -t "$SESSION" 2>/dev/null; then
  exec tmux attach -t "$SESSION"
fi

tmux new-session -d -s "$SESSION" -n "mon"

# Pane 0: ping
tmux send-keys -t "$SESSION":0.0 'nmon' C-m

tmux split-window -h -l 75 -t "$SESSION":0
tmux send-keys   -t "$SESSION":0.1 'htop' C-m

tmux split-window -v -l 10 -t "$SESSION":0
tmux send-keys   -t "$SESSION":0.2 'tty-clock -sc' C-m

tmux split-window -h -l 60 -t "$SESSION":0
tmux send-keys   -t "$SESSION":0.3 'nload' C-m

tmux split-window -v -l 8 -t "$SESSION":0.2
tmux send-keys   -t "$SESSION":0.3 'watch -n 10 "sensors | grep Co"' C-m

tmux split-window -v -l 5 -t "$SESSION":0.0
tmux send-keys   -t "$SESSION":0.1 'gping 8.8.8.8' C-m

tmux select-pane -t "$SESSION":0.0
tmux send-keys   -t "$SESSION":0.0 'd' C-m

tmux attach -t "$SESSION"


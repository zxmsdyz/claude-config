#!/usr/bin/env bash
# Claude Code Stop hook: Windows toast + 语音朗读当前任务名(tmux 窗口名 #W)。
# 由 ~/.claude/settings.json 的 Stop hook 调用；实际弹窗+朗读逻辑在同目录 notify.ps1。
# - 在 tmux 里：标题 = "[<session>] Claude Code"，正文/朗读 = 当前窗口名(#W)=任务摘要
# - 不在 tmux 里：退回固定文案 "任务已完成"

title="Claude Code"
line="任务已完成"

if [ -n "$TMUX_PANE" ] && command -v tmux >/dev/null 2>&1; then
  sess=$(tmux display-message -p -t "$TMUX_PANE" '#S' 2>/dev/null)
  task=$(tmux display-message -p -t "$TMUX_PANE" '#W' 2>/dev/null)
  [ -n "$sess" ] && title="[$sess] Claude Code"
  [ -n "$task" ] && line="$task"
fi

# 本文件可能是指向仓库的软链——解析真实路径，定位同目录的 notify.ps1
selfdir=$(dirname "$(readlink -f "$0")")
ps1win=$(wslpath -w "$selfdir/notify.ps1" 2>/dev/null)

# 参数直传给 PowerShell（不进 PS 字符串字面量，无需转义单引号）
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$ps1win" -Title "$title" -Line "$line" >/dev/null 2>&1

exit 0

#!/usr/bin/env bash
# Claude Code Stop hook: Windows toast，正文带上当前任务名（tmux 窗口名 #W）。
# 由 ~/.claude/settings.json 的 Stop hook 调用。
# - 在 tmux 里：标题 = "[<session>] Claude Code"，正文 = 当前窗口名(#W)=任务摘要
# - 不在 tmux 里：退回固定文案 "任务已完成"

title="Claude Code"
line="任务已完成"

if [ -n "$TMUX_PANE" ] && command -v tmux >/dev/null 2>&1; then
  sess=$(tmux display-message -p -t "$TMUX_PANE" '#S' 2>/dev/null)
  task=$(tmux display-message -p -t "$TMUX_PANE" '#W' 2>/dev/null)
  [ -n "$sess" ] && title="[$sess] Claude Code"
  [ -n "$task" ] && line="$task"
fi

# 转义：PowerShell 单引号字符串里字面单引号要写成两个；去掉换行防命令截断
esc() { printf '%s' "$1" | sed "s/'/''/g" | tr -d '\r\n'; }

powershell.exe -NoProfile -Command \
  "Import-Module BurntToast; New-BurntToastNotification -Text '$(esc "$title")', '$(esc "$line")'" >/dev/null 2>&1

exit 0

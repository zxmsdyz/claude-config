# claude-config

个人 Claude Code + tmux 配置备份。

## 文件映射

仓库内路径镜像 `$HOME`，安装时拷回（或 symlink）到对应位置：

| 仓库内 | 部署到 | 作用 |
|---|---|---|
| `.tmux.conf` | `~/.tmux.conf` | tmux 配置；开启 `automatic-rename`，窗口名自动跟随 Claude Code 当前任务摘要（取 `pane_title` 剥掉 spinner），新 tab 不再是 `bash`、无需手动改名 |
| `.claude/settings.json` | `~/.claude/settings.json` | Claude Code 设置；`Stop` hook 调用下面的脚本弹 Windows 通知 |
| `.claude/hooks/notify-done.sh` | `~/.claude/hooks/notify-done.sh` | Stop hook 脚本：任务结束时弹 Windows toast，正文 = 当前 tmux 窗口名（= 任务摘要），不在 tmux 时退回“任务已完成” |

## 安装（拷贝方式）

```bash
cp .tmux.conf ~/.tmux.conf
mkdir -p ~/.claude/hooks
cp .claude/settings.json ~/.claude/settings.json
cp .claude/hooks/notify-done.sh ~/.claude/hooks/notify-done.sh
chmod +x ~/.claude/hooks/notify-done.sh
tmux source-file ~/.tmux.conf   # 让运行中的 tmux 立即生效
```

> 注：仓库里是**副本**，之后改了本机 `~` 下的文件记得同步回仓库再 commit。
> 想让仓库成为唯一真源、编辑自动同步，可改用 symlink（如 GNU stow）。

## 依赖

- Windows toast 通知需 PowerShell 模块 `BurntToast`（`Install-Module BurntToast`）。
- `notify-done.sh` 通过 WSL interop 调 `powershell.exe`，仅在 WSL 环境有效。

## 不包含

不含任何凭证 / token / cookie / 会话数据（如 `~/.claude/.credentials.json`、`~/.claude/projects/` 等），仅纯配置。

# Minimal Neovim Config (Lazy.nvim)

🌐 [EN](README.md) | [TH](README.th.md) | [JP](README.jp.md) | [CN](README.cn.md) | [KR](README.kr.md)

![preview](init_example.jpg)

一个使用 `lazy.nvim` 的简单**单文件 Neovim 配置**。

## Features

- 插件管理器：lazy.nvim（自动引导）
- 文件浏览器（nvim-tree，自动打开）
- Telescope（模糊查找）
- 多主题支持并自动保存
- 注释支持
- Nerd Font 图标

## File Explorer

- 使用 nvim-tree
- 启动时自动打开
- 在左侧显示文件和文件夹

---

## Requirements

- Neovim >= 0.9  
- Git  
- Nerd Font（图标必需）

---

## Installation

克隆该配置：

```bash
git clone https://github.com/DragoonT/init-termux-neovim.git init
```

## Quick Install (Single File)

你可以只使用 "init.lua" 文件来安装此配置（无需克隆整个仓库）。

### Install

```bash
mkdir -p ~/.config/nvim
```
```bash
[ -f ~/.config/nvim/init.lua ] && cp ~/.config/nvim/init.lua ~/.config/nvim/init.lua.bak
```
```bash
curl -o ~/.config/nvim/init.lua https://raw.githubusercontent.com/DragoonT/init-termux-neovim/main/init.lua
```

启动 Neovim

```bash
nvim
```

首次启动时会自动安装插件。

---

## Recommended: Use tmux

建议在 `tmux` 中运行 Neovim，以避免 Termux 的 UI 问题（例如侧边栏消失）。

---

### Install (Termux)

```bash
pkg install tmux
```

### Usage
```bash
tmux
```

然后运行 Neovim：
```bash
nvim
```

---

## Nerd Font (Required for Icons)

此配置使用图标（文件树、UI 等），因此需要 **Nerd Font**。

否则图标会显示为方块或乱码。

### Termux Installation

```bash
mkdir -p ~/.termux
```
```bash
curl -L -o ~/.termux/font.ttf \
https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf
```
```bash
termux-reload-settings
```

### Recommended Fonts

- FiraCode Nerd Font
- JetBrainsMono Nerd Font
- Hack Nerd Font

### Notes

- Termux 只使用：`~/.termux/font.ttf`
- 安装后必须重新加载设置
- 必需用于：
  - nvim-tree
  - nvim-web-devicons

---

## Themes

- tokyonight  
- catppuccin  
- nightfox  
- onedark  
- gruvbox  
- kanagawa  

切换主题：

```vim
:colorscheme tokyonight
```

---

## OneDark styles

OneDark 专用命令：

```vim
:OneDark dark
:OneDark darker
:OneDark cool
:OneDark deep
:OneDark warm
:OneDark warmer
```

所选样式会自动保存，并在重启时恢复。

---

## Fuzzy Finder

- 已安装 Telescope，可直接使用

示例：

```vim
:Telescope find_files
```

- 切换主题

```vim
:Telescope colorscheme
```

---

## How it works

- `lazy.nvim` 会自动引导（无需手动安装）
- 主题保存在：

```bash
~/.config/nvim/theme.txt
```

- 所有配置都集中在一个 `init.lua` 文件中

---

# Which-Key Support

## Keybindings

> Leader 键 = `Space`

---

### Find Files
- `<Space>f` → 查找文件  
- `<Space>ff` → 在项目中查找文件（Telescope）

---

## Navigation & Editing

### Improved Copy Behavior

- `y` → 复制且保持选区

> yank 后仍保留选择，提升编辑效率

---

## Delete vs Cut (Custom Behavior)

默认情况下，Neovim 将**删除视为剪切**：
- `d` → 删除文本并保存到寄存器
- 可使用 `p` 粘贴

### Custom Delete (No Clipboard)

此配置添加了类似 VSCode 的**真正删除**：

- `<Space>d` → 删除但不保存
- `d` → 仍为剪切（默认行为）

### Configuration

```lua
-- 删除但不影响剪贴板
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')
```

### Summary

| Key | Action |
|-----|--------|
| `d` | Cut（删除 + 保存） |
| `<Space>d` | Delete（不保存） |
| `p` | Paste |

> 防止删除时覆盖剪贴板内容。

---

### Indentation (Improved)

- `<` → 向左缩进  
- `>` → 向右缩进  

> 使用 **1 个空格** 缩进（默认是 2–4）  
> 缩进后保持选区

---

### Comment
- `gcc` → 切换行注释  
- `gc` → 切换选区注释  

---

### Telescope
- `<Space>f` → 查找文件  
- `:Telescope find_files` → 手动执行  

---

## Run Code

按 `<Space>r` 在终端中运行项目入口文件（`app2.py`）

> 注意：不会运行当前文件，而是始终运行 `app2.py`

![run_code_preview](run_code_example.jpg)

## Optional: Run Current File (Fallback to app2.py)

如果你想运行当前文件，可以将快捷键替换为：

```lua
vim.keymap.set("n", "<leader>r", function()
  vim.cmd("w")

  local app = "app2.py"
  if vim.fn.filereadable(app) == 1 then
    vim.cmd("terminal python " .. app)
  else
    vim.cmd("terminal python %")
  end
end)
```

---

### Notes
- 使用 `Space` 作为 leader 键  
- 设计注重速度与简洁

---

## Plugin Management

```vim
:Lazy update  " 更新插件
:Lazy clean   " 删除未使用的插件
:Lazy sync    " 安装缺失的插件
```

---

## Reset

```bash
rm -rf ~/.local/share/nvim
```

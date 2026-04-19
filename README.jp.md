# Minimal Neovim Config (Lazy.nvim)

🌐 [EN](README.md) | [TH](README.th.md) | [JP](README.jp.md) | [CN](README.cn.md) | [KR](README.kr.md)

![preview](init_example.jpg)

`lazy.nvim`を使用したシンプルな**単一ファイルのNeovim設定**です。

## Features

- プラグインマネージャー: lazy.nvim（自動ブートストラップ）
- ファイルエクスプローラー（nvim-tree、自動起動）
- Telescope（ファジーファインダー）
- 複数テーマ対応（設定を保持）
- コメント機能
- Nerd Font アイコン

## File Explorer

- nvim-treeを使用
- 起動時に自動で開く
- 左側にファイルとフォルダを表示

---

## Requirements

- Neovim >= 0.9  
- Git  
- Nerd Font（アイコン用・必須）

---

## Installation

この設定をクローンします：

```bash
git clone https://github.com/DragoonT/init-termux-neovim.git init
```

## Quick Install (Single File)

この設定は "init.lua" ファイル1つだけでもインストールできます（リポジトリ全体のクローンは不要）。

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

Neovimを起動

```bash
nvim
```

初回起動時にプラグインが自動でインストールされます。

---

## Recommended: Use tmux

TermuxでのUI問題（例：サイドバーが消える）を防ぐため、`tmux` 内でNeovimを実行してください。

---

### Install (Termux)

```bash
pkg install tmux
```

### Usage
```bash
tmux
```

その後Neovimを起動：
```bash
nvim
```

---

## Nerd Font (Required for Icons)

この設定ではアイコン（ファイルツリー、UIなど）を使用するため、**Nerd Font** が必要です。

未インストールの場合、アイコンが四角や壊れた記号のように表示されます。

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

- Termuxは `~/.termux/font.ttf` のみ使用します
- インストール後は設定の再読み込みが必要です
- 必要な機能：
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

テーマ変更：

```vim
:colorscheme tokyonight
```

---

## OneDark styles

OneDark用の特別コマンド：

```vim
:OneDark dark
:OneDark darker
:OneDark cool
:OneDark deep
:OneDark warm
:OneDark warmer
```

選択したスタイルは自動的に保存され、再起動時に復元されます。

---

## Fuzzy Finder

- Telescopeはインストール済みですぐ使えます

例：

```vim
:Telescope find_files
```

- テーマ変更

```vim
:Telescope colorscheme
```

---

## How it works

- `lazy.nvim` は自動でブートストラップされます（手動インストール不要）
- テーマは以下に保存されます：

```bash
~/.config/nvim/theme.txt
```

- 設定はすべて1つの `init.lua` にまとめられています

---

# Which-Key Support

## Keybindings

> Leader key = `Space`

---

### Find Files
- `<Space>f` → ファイル検索  
- `<Space>ff` → プロジェクト全体検索（Telescope）

---

## Navigation & Editing

### Improved Copy Behavior

- `y` → 選択を維持したままコピー

> yank後も選択が維持されるため、効率よく編集できます

---

## Delete vs Cut (Custom Behavior)

デフォルトでは、Neovimは**削除 = カット**として動作します：
- `d` → テキストを削除し、レジスタに保存
- `p` で貼り付け可能

### Custom Delete (No Clipboard)

この設定ではVSCodeのような**本当の削除**を追加します：

- `<Space>d` → 保存せず削除
- `d` → 従来通りカット

### Configuration

```lua
-- クリップボードに保存せず削除
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')
```

### Summary

| Key | Action |
|-----|--------|
| `d` | Cut（削除＋保存） |
| `<Space>d` | Delete（保存なし） |
| `p` | Paste |

> 削除時にクリップボードが上書きされるのを防ぎます。

---

### Indentation (Improved)

- `<` → 左に移動  
- `>` → 右に移動  

> デフォルト（2〜4スペース）ではなく**1スペース単位**でインデント  
> 選択状態を維持

---

### Comment
- `gcc` → 行コメント切り替え  
- `gc` → 選択範囲コメント切り替え  

---

### Telescope
- `<Space>f` → ファイル検索  
- `:Telescope find_files` → 手動実行  

---

## Run Code

`<Space>r` を押すと、プロジェクトの実行ファイル（`app2.py`）をターミナルで実行します

> 注意：現在のファイルではなく、常に `app2.py` を実行します

![run_code_preview](run_code_example.jpg)

## Optional: Run Current File (Fallback to app2.py)

現在のファイルを実行したい場合は、以下のようにキーマップを変更してください：

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
- Leaderキーは `Space` を使用  
- シンプルさと高速性を重視

---

## Plugin Management

```vim
:Lazy update  " プラグインを更新
:Lazy clean   " 未使用のプラグインを削除
:Lazy sync    " 不足しているプラグインをインストール
```

---

## Reset

```bash
rm -rf ~/.local/share/nvim
```

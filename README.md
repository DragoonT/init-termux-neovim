# Minimal Neovim Config (Lazy.nvim)

🌐 [EN](README.md) | [TH](README_th.md) | [JP](README_jp.md) | [CN](README_cn.md) | [KR](README_kr.md)

![preview](init_example.png)

A powerful **single-file Neovim configuration** using `lazy.nvim` — designed to look and feel like VSCode.

## Features

- Plugin manager: lazy.nvim (auto bootstrap)
- VSCode-like dark theme (Carbonfox / Nightfox)
- File explorer: Neo-tree (auto opens, with right-click action menu)
- Telescope (fuzzy finder — Ctrl+P, Command Palette)
- LSP + Autocomplete (Mason, nvim-cmp, LuaSnip) — IntelliSense feel
- Treesitter syntax highlighting
- Git signs with inline blame
- Statusline (lualine) and tabline (bufferline) — VSCode style
- Integrated terminal (toggleterm — Ctrl+\`)
- Inline diagnostics (error-lens + lsp_lines)
- Indent guides, auto pairs, which-key popup
- Discord Rich Presence
- Dashboard (alpha-nvim)
- Run current file with F5 / `<Space>r`
- Nerd Font icons

---

## Requirements

- Neovim >= 0.9
- Git
- Nerd Font (required for icons)
- Node.js (for ts_ls, html, css, json LSP)
- Python (for pyright LSP)
- Rust / cargo (for rust_analyzer LSP)

---

## Installation

Clone this config:

```bash
git clone https://github.com/DragoonT/init-termux-neovim.git init
```

## Quick Install (Single File)

You can install this config using only the `init.lua` file (no need to clone the full repo).

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

Start Neovim:

```bash
nvim
```

Plugins will install automatically on first launch.

---

## Recommended: Use tmux

Run Neovim inside `tmux` to avoid UI issues in Termux (e.g. sidebar disappearing).

### Install (Termux)

```bash
pkg install tmux
```

### Usage

```bash
tmux
nvim
```

---

## Nerd Font (Required for Icons)

This config uses icons (file tree, UI, etc.), so you need a **Nerd Font**.

Without it, icons will look like squares or broken symbols.

### Termux Installation

```bash
mkdir -p ~/.termux
curl -L -o ~/.termux/font.ttf \
https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf
termux-reload-settings
```

### Recommended Fonts

- FiraCode Nerd Font
- JetBrainsMono Nerd Font
- Hack Nerd Font

### Notes

- Termux ONLY uses: `~/.termux/font.ttf`
- You must reload settings after installing
- Required for: Neo-tree, nvim-web-devicons, lualine, bufferline

---

## Theme

This config uses **Carbonfox** (from Nightfox) — a VSCode dark theme with matching colors for keywords, strings, variables, and UI elements.

Change theme at runtime:

```vim
:colorscheme nightfox
:colorscheme carbonfox
```

The active colorscheme can also be browsed with Telescope:

```vim
:Telescope colorscheme
```

---

## File Explorer (Neo-tree)

- Opens automatically on startup (left sidebar, width 30)
- Press `<Space>` on any file/folder for an action menu:
  - New file / New folder
  - Rename
  - Copy / Cut / Paste
  - Delete (with confirmation)
  - Copy path

### Keybindings

| Key | Action |
|-----|--------|
| `<leader>e` / `<C-b>` | Toggle Neo-tree |
| `<Space>` (in tree) | Open action menu |

---

## LSP & Autocomplete

Managed by **Mason**. The following language servers are auto-installed:

| Language | Server |
|----------|--------|
| Lua | lua_ls |
| JavaScript / TypeScript | ts_ls |
| Python | pyright |
| CSS | cssls |
| HTML | html |
| JSON | jsonls |
| Rust | rust_analyzer |

### LSP Keybindings

| Key | Action |
|-----|--------|
| `gd` | Go to Definition |
| `gD` | Go to Declaration |
| `gr` | Go to References |
| `gi` | Go to Implementation |
| `K` | Hover Docs |
| `<leader>rn` | Rename Symbol |
| `<leader>ca` | Code Action |
| `<leader>f` | Format File |
| `[d` / `]d` | Prev / Next Diagnostic |
| `<leader>e` | Show Diagnostic Float |

### Autocomplete

| Key | Action |
|-----|--------|
| `<Tab>` | Next item / expand snippet |
| `<S-Tab>` | Prev item |
| `<CR>` | Confirm selection |
| `<C-Space>` | Trigger completion |
| `<C-e>` | Abort |

---

## Telescope (Fuzzy Finder)

| Key | Action |
|-----|--------|
| `<C-p>` | Find files |
| `<C-S-p>` | Command palette |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fd` | Diagnostics |
| `<leader>fr` | Recent files |
| `<leader>ff` | Find text in project |
| `<leader>fa` | Find all files (home dir) |
| `<leader>fs` | Find files from current file's folder |
| `<leader>th` | Browse colorschemes |
| `<leader>vc` | Find in nvim config |

---

## Run Code (F5 / `<Space>r`)

Press `<F5>`, `<C-F5>`, or `<leader>r` to run the **current file** in a terminal split.

Supported filetypes:

| Filetype | Runner |
|----------|--------|
| Python | `python file.py` |
| JavaScript | `node file.js` |
| TypeScript / TSX | `npx ts-node file.ts` |
| Lua | `lua file.lua` |
| Bash / sh | `bash file.sh` |
| PowerShell | `powershell -File file.ps1` |
| Rust | `cargo run` |
| Go | `go run file.go` |
| C | `gcc` → run output |
| C++ | `g++` → run output |
| Java | `javac` → `java` |
| PHP | `php file.php` |
| Ruby | `ruby file.rb` |

---

## Terminal (Toggleterm)

| Key | Action |
|-----|--------|
| `<C-\`` >` | Toggle terminal |
| `<leader>t1` | Terminal 1 |
| `<leader>t2` | Terminal 2 |
| `<leader>t3` | Terminal 3 |
| `<Esc>` (in terminal) | Exit to normal mode |

---

## Navigation & Editing

### Save / Quit

| Key | Action |
|-----|--------|
| `<C-s>` | Save |
| `<leader>q` / `<C-q>` | Quit all |
| `<leader>wq` | Save all and quit |

### Undo / Redo

| Key | Action |
|-----|--------|
| `<C-z>` | Undo |
| `<C-y>` | Redo |

### Copy / Paste / Delete

| Key | Action |
|-----|--------|
| `y` | Copy (keeps visual selection) |
| `<C-c>` (visual) | Copy to system clipboard |
| `<C-v>` | Paste from system clipboard |
| `<leader>d` | Delete without affecting clipboard |
| `d` | Cut (delete + save to register) |

### Other

| Key | Action |
|-----|--------|
| `<C-a>` / `<leader>a` | Select all |
| `<C-w>` | Close buffer |
| `<A-Up>` / `<A-Down>` | Move line up/down |
| `<A-S-Down>` | Duplicate line |
| `<C-/>` | Toggle comment |
| `<Tab>` / `<S-Tab>` (visual) | Indent / De-indent |
| `<C-h/j/k/l>` | Navigate splits |
| `<C-Tab>` / `<C-S-Tab>` | Next / Prev buffer tab |
| `<Esc>` | Clear search highlight |

---

## Git (Gitsigns)

- Gutter signs for added / changed / deleted lines
- Inline git blame on current line (500ms delay)
- Format: `author, YYYY-MM-DD - summary`

---

## Plugin Management

```vim
:Lazy update   " update plugins
:Lazy clean    " remove unused plugins
:Lazy sync     " install missing plugins
```

---

## Reset

```bash
rm -rf ~/.local/share/nvim
```

---

## Windows Support

On Windows, the config automatically:
- Sets PowerShell as the shell
- Uses `win32yank.exe` for clipboard integration

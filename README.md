# Minimal Neovim Config (Lazy.nvim)

A simple **single-file Neovim configuration** using `lazy.nvim`.

## Features

- Plugin manager: lazy.nvim (auto bootstrap)
- File explorer (nvim-tree, auto opens)
- Telescope (fuzzy finder)
- Multiple themes with persistence
- Comment support
- Nerd Font icons

---

## Requirements

- Neovim >= 0.9  
- Git  
- Nerd Font (required for icons)

---

## Installation

Clone this config:

```
git clone https://github.com/DragoonT/init-termux-neovim.git ~/.config/nvim
```

Start Neovim:

```
nvim
```

Plugins will install automatically on first launch.

---

## Nerd Font (Required for Icons)

This config uses icons (file tree, UI, etc.), so you need a **Nerd Font**.

Without it, icons will look like squares or broken symbols.

### Termux Installation

```
mkdir -p ~/.termux
```
```
curl -L -o ~/.termux/font.ttf \
https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf
```
```
termux-reload-settings
```

### Test

```
echo "        "
```

If icons display correctly → you're good

### Recommended Fonts

- FiraCode Nerd Font
- JetBrainsMono Nerd Font
- Hack Nerd Font

### Notes

- Termux ONLY uses: `~/.termux/font.ttf`
- You must reload settings after installing
- Required for:
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

Change theme:

```
:colorscheme tokyonight
```

---

## OneDark styles

Special command for OneDark:

```
:OneDark dark
:OneDark darker
:OneDark cool
:OneDark deep
:OneDark warm
:OneDark warmer
```

Selected style is saved automatically and restored on restart.

---

## File Explorer

- Uses nvim-tree
- Opens automatically on startup
- Shows files and folders on the left

---

## Fuzzy Finder

- Telescope installed and ready

Example:

```
:Telescope find_files
```

- Change themes

```
:Telescope colorscheme
```

---

## Commenting

- `gcc` → toggle comment
- `gc` (visual mode)

---

## How it works

- `lazy.nvim` bootstraps automatically (no manual install needed)
- Theme is saved in:

```
~/.config/nvim/theme.txt
```

- Config is fully contained in one `init.lua` file

---

## Plugin Management

```
:Lazy update  " update plugins
:Lazy clean   " remove unused plugins
:Lazy sync    " install missing plugins
```

---

## Reset

```
rm -rf ~/.local/share/nvim
```

---

## Preview

- Sidebar file tree on startup
- Clean UI with selectable themes
- Lightweight and fast

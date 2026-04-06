# Minimal Neovim Config (Lazy.nvim)

🌐 [EN](README.md) | [TH](README.th.md) | [JP](README.jp.md) | [CN](README.cn.md) | [KR](README.kr.md)

![preview](init_example.jpg)

`lazy.nvim`을 사용하는 간단한 **단일 파일 Neovim 설정**입니다.

## Features

- 플러그인 매니저: lazy.nvim (자동 부트스트랩)
- 파일 탐색기 (nvim-tree, 자동 실행)
- Telescope (퍼지 검색)
- 여러 테마 및 설정 유지
- 주석(Comment) 지원
- Nerd Font 아이콘

## File Explorer

- nvim-tree 사용
- 시작 시 자동으로 열림
- 왼쪽에 파일과 폴더 표시

---

## Requirements

- Neovim >= 0.9  
- Git  
- Nerd Font (아이콘용 필수)

---

## Installation

이 설정을 클론하세요:

```bash
git clone https://github.com/DragoonT/init-termux-neovim.git init
```

## Quick Install (Single File)

이 설정은 "init.lua" 파일 하나만으로도 설치할 수 있습니다 (전체 repo 클론 불필요).

### Install

```bash
mkdir -p ~/.config/nvim
```
```bash
# 기존 설정이 있다면 백업
[ -f ~/.config/nvim/init.lua ] && cp ~/.config/nvim/init.lua ~/.config/nvim/init.lua.bak
```
```bash
# init.lua 다운로드
curl -o ~/.config/nvim/init.lua https://raw.githubusercontent.com/DragoonT/init-termux-neovim/main/init.lua
```

Neovim 실행

```bash
nvim
```

처음 실행 시 플러그인이 자동으로 설치됩니다.

---

## Recommended: Use tmux

Termux에서 UI 문제(예: 사이드바 사라짐)를 방지하려면 `tmux` 안에서 Neovim을 실행하세요.

---

### Install (Termux)

```bash
pkg install tmux
```

### Usage
```bash
tmux
```

그 다음 Neovim 실행:
```bash
nvim
```

---

## Nerd Font (Required for Icons)

이 설정은 아이콘(file tree, UI 등)을 사용하므로 **Nerd Font**가 필요합니다.

설치하지 않으면 아이콘이 깨지거나 네모로 보일 수 있습니다.

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

- Termux는 `~/.termux/font.ttf`만 사용합니다
- 설치 후 설정을 다시 불러와야 합니다
- 필요 대상:
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

테마 변경:

```vim
:colorscheme tokyonight
```

---

## OneDark styles

OneDark 전용 명령어:

```vim
:OneDark dark
:OneDark darker
:OneDark cool
:OneDark deep
:OneDark warm
:OneDark warmer
```

선택한 스타일은 자동으로 저장되고 재시작 시 복원됩니다.

---

## Fuzzy Finder

- Telescope 설치 및 사용 가능

예시:

```vim
:Telescope find_files
```

- 테마 변경

```vim
:Telescope colorscheme
```

---

## How it works

- `lazy.nvim`이 자동으로 부트스트랩됨 (수동 설치 불필요)
- 테마는 다음 위치에 저장됨:

```bash
~/.config/nvim/theme.txt
```

- 설정은 하나의 `init.lua` 파일에 모두 포함됨

---

# Which-Key Support

## Keybindings

> Leader key = `Space`

---

### Find Files
- `<Space>f` → 파일 찾기  
- `<Space>ff` → 프로젝트 전체 검색 (Telescope)

---

## Navigation & Editing

### Improved Copy Behavior

- `y` → 선택 유지 상태로 복사

> yank 후에도 선택이 유지되어 빠르게 작업 가능

---

## Delete vs Cut (Custom Behavior)

기본적으로 Neovim은 **삭제 = 잘라내기**로 동작합니다:
- `d` → 텍스트 삭제 + 레지스터에 저장
- 이후 `p`로 붙여넣기 가능

### Custom Delete (No Clipboard)

이 설정은 VSCode처럼 **진짜 삭제 기능**을 추가합니다:

- `<Space>d` → 저장 없이 삭제
- `d` → 기존처럼 cut 유지

### Configuration

```lua
-- 클립보드에 저장하지 않고 삭제
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')
```

### Summary

| Key | Action |
|-----|--------|
| `d` | Cut (삭제 + 저장) |
| `<Space>d` | Delete (저장 안함) |
| `p` | Paste |

> 삭제 시 클립보드가 덮어쓰이지 않도록 도와줍니다.

---

### Indentation (Improved)

- `<` → 왼쪽 이동  
- `>` → 오른쪽 이동  

> 기본(2~4칸) 대신 **1칸 단위**로 이동  
> 선택 상태 유지됨

---

### Comment
- `gcc` → 줄 주석 토글  
- `gc` → 선택 영역 주석 토글  

---

### Telescope
- `<Space>f` → 파일 찾기  
- `:Telescope find_files` → 직접 실행  

---

## Run Code

`<Space>r`을 눌러 프로젝트 실행 파일(`app2.py`)을 터미널에서 실행합니다

> 참고: 현재 파일이 아닌 항상 `app2.py`를 실행합니다

![run_code_preview](run_code_example.jpg)

## Optional: Run Current File (Fallback to app2.py)

현재 파일을 실행하도록 변경하려면 아래 코드로 교체하세요:

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
- Leader 키는 `Space` 사용  
- 속도와 단순함 중심 설계

---

## Plugin Management

```vim
:Lazy update  " 플러그인 업데이트
:Lazy clean   " 사용하지 않는 플러그인 삭제
:Lazy sync    " 누락된 플러그인 설치
```

---

## Reset

```bash
rm -rf ~/.local/share/nvim
```

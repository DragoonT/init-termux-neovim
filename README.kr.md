# Minimal Neovim Config (Lazy.nvim)

🌐 [EN](README.md) | [TH](README_th.md) | [JP](README_jp.md) | [CN](README_cn.md) | [KR](README_kr.md)

![preview](init_example.png)

`lazy.nvim`을 사용하는 VSCode처럼 생긴 **단일 파일 Neovim 설정**입니다.

## Features

- 플러그인 매니저: lazy.nvim (자동 부트스트랩)
- VSCode 스타일 다크 테마 (Carbonfox / Nightfox)
- 파일 탐색기: Neo-tree (자동 실행, 우클릭 액션 메뉴 포함)
- Telescope (퍼지 검색 — Ctrl+P, 명령 팔레트)
- LSP + 자동완성 (Mason, nvim-cmp, LuaSnip) — IntelliSense 느낌
- Treesitter 문법 하이라이팅
- Git 사인 + 인라인 blame
- 상태바 (lualine), 탭바 (bufferline) — VSCode 스타일
- 통합 터미널 (toggleterm — Ctrl+\`)
- 인라인 진단 (error-lens + lsp_lines)
- 들여쓰기 가이드, 자동 괄호, which-key 팝업
- Discord Rich Presence
- 대시보드 (alpha-nvim)
- F5 / `<Space>r` 로 현재 파일 실행
- Nerd Font 아이콘

---

## Requirements

- Neovim >= 0.9
- Git
- Nerd Font (아이콘용 필수)
- Node.js (ts_ls, html, css, json LSP용)
- Python (pyright LSP용)
- Rust / cargo (rust_analyzer LSP용)

---

## Installation

이 설정을 클론하세요:

```bash
git clone https://github.com/DragoonT/init-termux-neovim.git init
```

## Quick Install (Single File)

`init.lua` 파일 하나만으로도 설치할 수 있습니다 (전체 repo 클론 불필요).

```bash
mkdir -p ~/.config/nvim
[ -f ~/.config/nvim/init.lua ] && cp ~/.config/nvim/init.lua ~/.config/nvim/init.lua.bak
curl -o ~/.config/nvim/init.lua https://raw.githubusercontent.com/DragoonT/init-termux-neovim/main/init.lua
```

Neovim 실행:

```bash
nvim
```

처음 실행 시 플러그인이 자동으로 설치됩니다.

---

## Recommended: Use tmux

Termux에서 UI 문제(예: 사이드바 사라짐)를 방지하려면 `tmux` 안에서 Neovim을 실행하세요.

```bash
pkg install tmux
tmux
nvim
```

---

## Nerd Font (Required for Icons)

이 설정은 아이콘을 사용하므로 **Nerd Font**가 필요합니다. 없으면 아이콘이 깨지거나 네모로 보입니다.

### Termux 설치

```bash
mkdir -p ~/.termux
curl -L -o ~/.termux/font.ttf \
https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf
termux-reload-settings
```

### 추천 폰트

- FiraCode Nerd Font
- JetBrainsMono Nerd Font
- Hack Nerd Font

---

## Theme

이 설정은 **Carbonfox** (Nightfox에서 제공) 를 사용 — VSCode 색상에 맞춘 다크 테마입니다.

런타임 테마 변경:

```vim
:colorscheme carbonfox
:colorscheme nightfox
:Telescope colorscheme
```

---

## 파일 탐색기 (Neo-tree)

- 시작 시 자동으로 열림 (왼쪽 사이드바, 너비 30)
- 파일/폴더에서 `<Space>` 를 눌러 액션 메뉴 열기:
  - 새 파일 / 새 폴더
  - 이름 변경
  - 복사 / 잘라내기 / 붙여넣기
  - 삭제 (확인 필요)
  - 경로 복사

| 키 | 기능 |
|----|------|
| `<leader>e` / `<C-b>` | Neo-tree 토글 |
| `<Space>` (트리 내) | 액션 메뉴 열기 |

---

## LSP & 자동완성

**Mason** 으로 관리. 아래 언어 서버가 자동 설치됩니다:

| 언어 | 서버 |
|------|------|
| Lua | lua_ls |
| JavaScript / TypeScript | ts_ls |
| Python | pyright |
| CSS | cssls |
| HTML | html |
| JSON | jsonls |
| Rust | rust_analyzer |

### LSP 단축키

| 키 | 기능 |
|----|------|
| `gd` | 정의로 이동 |
| `gD` | 선언으로 이동 |
| `gr` | 참조 보기 |
| `gi` | 구현으로 이동 |
| `K` | 호버 문서 |
| `<leader>rn` | 심볼 이름 변경 |
| `<leader>ca` | 코드 액션 |
| `<leader>f` | 파일 포맷 |
| `[d` / `]d` | 이전/다음 진단 |
| `<leader>e` | 진단 플로트 표시 |

### 자동완성

| 키 | 기능 |
|----|------|
| `<Tab>` | 다음 항목 / 스니펫 확장 |
| `<S-Tab>` | 이전 항목 |
| `<CR>` | 선택 확정 |
| `<C-Space>` | 완성 트리거 |
| `<C-e>` | 취소 |

---

## Telescope (퍼지 검색)

| 키 | 기능 |
|----|------|
| `<C-p>` | 파일 찾기 |
| `<C-S-p>` | 명령 팔레트 |
| `<leader>fg` | 라이브 grep |
| `<leader>fb` | 버퍼 목록 |
| `<leader>fd` | 진단 |
| `<leader>fr` | 최근 파일 |
| `<leader>ff` | 프로젝트 전체 텍스트 검색 |
| `<leader>fa` | 홈 디렉토리 전체 파일 검색 |
| `<leader>fs` | 현재 파일 폴더에서 검색 |
| `<leader>th` | 컬러스킴 목록 |
| `<leader>vc` | nvim 설정 내 검색 |

---

## 코드 실행 (F5 / `<Space>r`)

`<F5>`, `<C-F5>`, 또는 `<leader>r` 을 눌러 **현재 파일** 을 터미널에서 실행합니다.

지원 파일 타입:

| 파일 타입 | 실행 방법 |
|-----------|-----------|
| Python | `python file.py` |
| JavaScript | `node file.js` |
| TypeScript / TSX | `npx ts-node file.ts` |
| Lua | `lua file.lua` |
| Bash / sh | `bash file.sh` |
| PowerShell | `powershell -File file.ps1` |
| Rust | `cargo run` |
| Go | `go run file.go` |
| C | `gcc` → 출력 실행 |
| C++ | `g++` → 출력 실행 |
| Java | `javac` → `java` |
| PHP | `php file.php` |
| Ruby | `ruby file.rb` |

---

## 터미널 (Toggleterm)

| 키 | 기능 |
|----|------|
| `<C-\`>` | 터미널 토글 |
| `<leader>t1/t2/t3` | 터미널 1/2/3 |
| `<Esc>` (터미널 내) | 노멀 모드로 |

---

## 탐색 & 편집

### 저장 / 종료

| 키 | 기능 |
|----|------|
| `<C-s>` | 저장 |
| `<leader>q` / `<C-q>` | 전체 종료 |
| `<leader>wq` | 전체 저장 후 종료 |

### 되돌리기 / 다시 실행

| 키 | 기능 |
|----|------|
| `<C-z>` | 되돌리기 |
| `<C-y>` | 다시 실행 |

### 복사 / 붙여넣기 / 삭제

| 키 | 기능 |
|----|------|
| `y` | 복사 (선택 유지) |
| `<C-c>` (비주얼) | 시스템 클립보드로 복사 |
| `<C-v>` | 시스템 클립보드에서 붙여넣기 |
| `<leader>d` | 클립보드 영향 없이 삭제 |
| `d` | 잘라내기 (삭제 + 레지스터 저장) |

### 기타

| 키 | 기능 |
|----|------|
| `<C-a>` / `<leader>a` | 전체 선택 |
| `<C-w>` | 버퍼 닫기 |
| `<A-Up>` / `<A-Down>` | 줄 위/아래 이동 |
| `<A-S-Down>` | 줄 복제 |
| `<C-/>` | 주석 토글 |
| `<Tab>` / `<S-Tab>` (비주얼) | 들여쓰기 증가/감소 |
| `<C-h/j/k/l>` | 분할 창 이동 |
| `<C-Tab>` / `<C-S-Tab>` | 다음/이전 버퍼 탭 |
| `<Esc>` | 검색 하이라이트 지우기 |

---

## Git (Gitsigns)

- 추가 / 수정 / 삭제 줄의 거터 사인
- 현재 줄 인라인 git blame (500ms 지연)
- 형식: `작성자, YYYY-MM-DD - 요약`

---

## 플러그인 관리

```vim
:Lazy update   " 플러그인 업데이트
:Lazy clean    " 사용하지 않는 플러그인 삭제
:Lazy sync     " 누락된 플러그인 설치
```

---

## 초기화

```bash
rm -rf ~/.local/share/nvim
```

---

## Windows 지원

Windows에서 자동으로:
- PowerShell을 셸로 설정
- `win32yank.exe`로 클립보드 연동

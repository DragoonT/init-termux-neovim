# Minimal Neovim Config (Lazy.nvim)

🌐 [EN](README.md) | [TH](README_th.md) | [JP](README_jp.md) | [CN](README_cn.md) | [KR](README_kr.md)

![preview](init_example.png)

การตั้งค่า **Neovim แบบไฟล์เดียว** ที่มีหน้าตาและการใช้งานคล้าย VSCode โดยใช้ `lazy.nvim`

## Features

- ตัวจัดการ plugin: lazy.nvim (ติดตั้งอัตโนมัติ)
- ธีมดาร์กสไตล์ VSCode (Carbonfox / Nightfox)
- File explorer: Neo-tree (เปิดอัตโนมัติ มีเมนูคลิกขวา)
- Telescope (ค้นหาไฟล์ — Ctrl+P, Command Palette)
- LSP + เติมโค้ดอัตโนมัติ (Mason, nvim-cmp, LuaSnip) — รู้สึกเหมือน IntelliSense
- Treesitter ไฮไลต์โค้ด
- Git signs + inline blame
- Status bar (lualine) และ Tab bar (bufferline) — สไตล์ VSCode
- Terminal ในตัว (toggleterm — Ctrl+\`)
- แสดง error ในบรรทัด (error-lens + lsp_lines)
- เส้นนำ indent, วงเล็บอัตโนมัติ, which-key popup
- Discord Rich Presence
- หน้า dashboard (alpha-nvim)
- กด F5 / `<Space>r` เพื่อรันไฟล์ปัจจุบัน
- ไอคอน Nerd Font

---

## Requirements

- Neovim >= 0.9
- Git
- Nerd Font (จำเป็นสำหรับไอคอน)
- Node.js (สำหรับ ts_ls, html, css, json LSP)
- Python (สำหรับ pyright LSP)
- Rust / cargo (สำหรับ rust_analyzer LSP)

---

## Installation

Clone config นี้:

```bash
git clone https://github.com/DragoonT/init-termux-neovim.git init
```

## Quick Install (Single File)

ติดตั้งได้โดยใช้แค่ไฟล์ `init.lua` (ไม่จำเป็นต้อง clone ทั้ง repo)

```bash
mkdir -p ~/.config/nvim
[ -f ~/.config/nvim/init.lua ] && cp ~/.config/nvim/init.lua ~/.config/nvim/init.lua.bak
curl -o ~/.config/nvim/init.lua https://raw.githubusercontent.com/DragoonT/init-termux-neovim/main/init.lua
```

เริ่มใช้งาน Neovim:

```bash
nvim
```

Plugin จะถูกติดตั้งอัตโนมัติเมื่อเปิดครั้งแรก

---

## Recommended: Use tmux

แนะนำให้รัน Neovim ใน `tmux` เพื่อหลีกเลี่ยงปัญหา UI ใน Termux (เช่น sidebar หาย)

```bash
pkg install tmux
tmux
nvim
```

---

## Nerd Font (Required for Icons)

config นี้ใช้ไอคอน จึงต้องมี **Nerd Font** มิฉะนั้นไอคอนจะแสดงเป็นสี่เหลี่ยมหรือสัญลักษณ์ผิดพลาด

### Termux Installation

```bash
mkdir -p ~/.termux
curl -L -o ~/.termux/font.ttf \
https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf
termux-reload-settings
```

### แนะนำฟอนต์

- FiraCode Nerd Font
- JetBrainsMono Nerd Font
- Hack Nerd Font

---

## Theme

config นี้ใช้ **Carbonfox** (จาก Nightfox) — ธีมดาร์กที่ตรงกับสีของ VSCode

เปลี่ยนธีม:

```vim
:colorscheme carbonfox
:colorscheme nightfox
:Telescope colorscheme
```

---

## File Explorer (Neo-tree)

- เปิดอัตโนมัติเมื่อเริ่ม (sidebar ซ้าย ความกว้าง 30)
- กด `<Space>` ที่ไฟล์/โฟลเดอร์เพื่อเปิดเมนูการกระทำ:
  - ไฟล์ใหม่ / โฟลเดอร์ใหม่
  - เปลี่ยนชื่อ
  - คัดลอก / ตัด / วาง
  - ลบ (ยืนยันก่อน)
  - คัดลอก path

| ปุ่ม | การกระทำ |
|------|----------|
| `<leader>e` / `<C-b>` | เปิด/ปิด Neo-tree |
| `<Space>` (ในต้นไม้) | เปิดเมนูการกระทำ |

---

## LSP & เติมโค้ดอัตโนมัติ

จัดการโดย **Mason** ติดตั้ง language server อัตโนมัติ:

| ภาษา | Server |
|------|--------|
| Lua | lua_ls |
| JavaScript / TypeScript | ts_ls |
| Python | pyright |
| CSS | cssls |
| HTML | html |
| JSON | jsonls |
| Rust | rust_analyzer |

### LSP Keybindings

| ปุ่ม | การกระทำ |
|------|----------|
| `gd` | ไปยัง Definition |
| `gD` | ไปยัง Declaration |
| `gr` | ดู References |
| `gi` | ไปยัง Implementation |
| `K` | Hover Docs |
| `<leader>rn` | เปลี่ยนชื่อ Symbol |
| `<leader>ca` | Code Action |
| `<leader>f` | จัดรูปแบบไฟล์ |
| `[d` / `]d` | Diagnostic ก่อน/ถัดไป |
| `<leader>e` | แสดง Diagnostic float |

### การเติมโค้ด

| ปุ่ม | การกระทำ |
|------|----------|
| `<Tab>` | รายการถัดไป / ขยาย snippet |
| `<S-Tab>` | รายการก่อนหน้า |
| `<CR>` | ยืนยันการเลือก |
| `<C-Space>` | เรียก completion |
| `<C-e>` | ยกเลิก |

---

## Telescope (Fuzzy Finder)

| ปุ่ม | การกระทำ |
|------|----------|
| `<C-p>` | ค้นหาไฟล์ |
| `<C-S-p>` | Command palette |
| `<leader>fg` | Live grep |
| `<leader>fb` | รายการ buffer |
| `<leader>fd` | Diagnostics |
| `<leader>fr` | ไฟล์ล่าสุด |
| `<leader>ff` | ค้นหาข้อความในโปรเจค |
| `<leader>fa` | ค้นหาไฟล์ทั้งหมดในโฮม |
| `<leader>fs` | ค้นหาจากโฟลเดอร์ไฟล์ปัจจุบัน |
| `<leader>th` | เลือก colorscheme |
| `<leader>vc` | ค้นหาใน nvim config |

---

## รันโค้ด (F5 / `<Space>r`)

กด `<F5>`, `<C-F5>`, หรือ `<leader>r` เพื่อรัน **ไฟล์ปัจจุบัน** ในหน้าต่าง terminal

รองรับ filetype:

| Filetype | วิธีรัน |
|----------|--------|
| Python | `python file.py` |
| JavaScript | `node file.js` |
| TypeScript / TSX | `npx ts-node file.ts` |
| Lua | `lua file.lua` |
| Bash / sh | `bash file.sh` |
| PowerShell | `powershell -File file.ps1` |
| Rust | `cargo run` |
| Go | `go run file.go` |
| C | `gcc` → รัน output |
| C++ | `g++` → รัน output |
| Java | `javac` → `java` |
| PHP | `php file.php` |
| Ruby | `ruby file.rb` |

---

## Terminal (Toggleterm)

| ปุ่ม | การกระทำ |
|------|----------|
| `<C-\`>` | เปิด/ปิด terminal |
| `<leader>t1/t2/t3` | Terminal 1/2/3 |
| `<Esc>` (ใน terminal) | ออกสู่ normal mode |

---

## การนำทางและการแก้ไข

### บันทึก / ออก

| ปุ่ม | การกระทำ |
|------|----------|
| `<C-s>` | บันทึก |
| `<leader>q` / `<C-q>` | ออกทั้งหมด |
| `<leader>wq` | บันทึกทั้งหมดแล้วออก |

### Undo / Redo

| ปุ่ม | การกระทำ |
|------|----------|
| `<C-z>` | Undo |
| `<C-y>` | Redo |

### คัดลอก / วาง / ลบ

| ปุ่ม | การกระทำ |
|------|----------|
| `y` | คัดลอก (คงการเลือกไว้) |
| `<C-c>` (visual) | คัดลอกไปยัง clipboard ระบบ |
| `<C-v>` | วางจาก clipboard ระบบ |
| `<leader>d` | ลบโดยไม่กระทบ clipboard |
| `d` | ตัด (ลบ + บันทึกใน register) |

### อื่นๆ

| ปุ่ม | การกระทำ |
|------|----------|
| `<C-a>` / `<leader>a` | เลือกทั้งหมด |
| `<C-w>` | ปิด buffer |
| `<A-Up>` / `<A-Down>` | ย้ายบรรทัดขึ้น/ลง |
| `<A-S-Down>` | ทำสำเนาบรรทัด |
| `<C-/>` | สลับ comment |
| `<Tab>` / `<S-Tab>` (visual) | เพิ่ม/ลด indent |
| `<C-h/j/k/l>` | ย้ายระหว่าง split |
| `<C-Tab>` / `<C-S-Tab>` | ถัดไป/ก่อนหน้า buffer tab |
| `<Esc>` | ล้าง search highlight |

---

## Git (Gitsigns)

- แสดงสัญลักษณ์บรรทัดที่เพิ่ม / แก้ไข / ลบ
- แสดง git blame แบบ inline ที่บรรทัดปัจจุบัน (หน่วงเวลา 500ms)
- รูปแบบ: `ผู้เขียน, YYYY-MM-DD - สรุป`

---

## จัดการ Plugin

```vim
:Lazy update   " อัปเดต plugin
:Lazy clean    " ลบ plugin ที่ไม่ได้ใช้
:Lazy sync     " ติดตั้ง plugin ที่ขาด
```

---

## รีเซ็ต

```bash
rm -rf ~/.local/share/nvim
```

---

## รองรับ Windows

บน Windows จะตั้งค่าอัตโนมัติ:
- ใช้ PowerShell เป็น shell
- ใช้ `win32yank.exe` สำหรับ clipboard

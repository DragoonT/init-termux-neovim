# Minimal Neovim Config (Lazy.nvim)

🌐 [EN](README.md) | [TH](README.th.md) | [JP](README.jp.md) | [CN](README.cn.md) | [KR](README.kr.md)

![preview](init_example.jpg)

การตั้งค่า **Neovim แบบไฟล์เดียว (single-file)** อย่างง่าย โดยใช้ `lazy.nvim`

## Features

- ตัวจัดการ plugin: lazy.nvim (ติดตั้งอัตโนมัติ)
- File explorer (nvim-tree, เปิดอัตโนมัติ)
- Telescope (ค้นหาไฟล์แบบ fuzzy)
- ธีมหลายแบบ พร้อมบันทึกค่า
- รองรับการ comment
- ไอคอน Nerd Font

## File Explorer

- ใช้ nvim-tree
- เปิดอัตโนมัติเมื่อเริ่มใช้งาน
- แสดงไฟล์และโฟลเดอร์ทางด้านซ้าย

---

## Requirements

- Neovim >= 0.9  
- Git  
- Nerd Font (จำเป็นสำหรับไอคอน)

---

## Installation

Clone config นี้:

```bash
git clone https://github.com/DragoonT/init-termux-neovim.git init
```

## Quick Install (Single File)

คุณสามารถติดตั้ง config นี้ได้โดยใช้แค่ไฟล์ "init.lua" (ไม่จำเป็นต้อง clone ทั้ง repo)

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

เริ่มใช้งาน Neovim

```bash
nvim
```

Plugin จะถูกติดตั้งอัตโนมัติเมื่อเปิดใช้งานครั้งแรก

---

## Recommended: Use tmux

แนะนำให้รัน Neovim ภายใน `tmux` เพื่อหลีกเลี่ยงปัญหา UI ใน Termux (เช่น sidebar หาย)

---

### Install (Termux)

```bash
pkg install tmux
```

### Usage

```bash
tmux
```

จากนั้นรัน Neovim:

```bash
nvim
```

---

## Nerd Font (Required for Icons)

config นี้ใช้ไอคอน (file tree, UI ฯลฯ) ดังนั้นจำเป็นต้องใช้ **Nerd Font**

หากไม่มี ไอคอนจะแสดงเป็นสี่เหลี่ยมหรือสัญลักษณ์ผิดพลาด

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

- Termux ใช้แค่: `~/.termux/font.ttf`
- ต้อง reload settings หลังติดตั้ง
- จำเป็นสำหรับ:
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

เปลี่ยนธีม:

```vim
:colorscheme tokyonight
```

---

## OneDark styles

คำสั่งพิเศษสำหรับ OneDark:

```vim
:OneDark dark
:OneDark darker
:OneDark cool
:OneDark deep
:OneDark warm
:OneDark warmer
```

รูปแบบที่เลือกจะถูกบันทึกและเรียกใช้อัตโนมัติเมื่อเปิดใหม่

---

## Fuzzy Finder

- มี Telescope พร้อมใช้งาน

ตัวอย่าง:

```vim
:Telescope find_files
```

- เปลี่ยนธีม

```vim
:Telescope colorscheme
```

---

## How it works

- `lazy.nvim` จะติดตั้งอัตโนมัติ (ไม่ต้องติดตั้งเอง)
- ธีมจะถูกบันทึกไว้ที่:

```bash
~/.config/nvim/theme.txt
```

- config ทั้งหมดอยู่ในไฟล์ `init.lua` ไฟล์เดียว

---

# Which-Key Support

## Keybindings

> Leader key = `Space`

---

### Find Files

- `<Space>f` → ค้นหาไฟล์  
- `<Space>ff` → ค้นหาไฟล์ทั้งโปรเจค (Telescope)

---

## Navigation & Editing

### Improved Copy Behavior

- `y` → คัดลอกโดยไม่หลุด selection

> ยังคงเลือกข้อความไว้หลัง copy เพื่อให้แก้ไขต่อได้เร็วขึ้น

---

## Delete vs Cut (Custom Behavior)

ค่าเริ่มต้นของ Neovim:

- `d` → ลบข้อความ **และบันทึกลง clipboard/register**
- สามารถวางได้ด้วย `p`

### Custom Delete (No Clipboard)

config นี้เพิ่มการลบแบบ “ไม่บันทึก” (เหมือน VSCode):

- `<Space>d` → ลบโดยไม่บันทึก
- `d` → ยังเป็น cut ตามปกติ

### Configuration

```lua
-- ลบแบบไม่ลง clipboard
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')
```

### Summary

| Key | Action |
|-----|--------|
| `d` | Cut (ลบ + บันทึก) |
| `<Space>d` | Delete (ไม่บันทึก) |
| `p` | Paste |

> ช่วยป้องกันการเขียนทับ clipboard โดยไม่ตั้งใจ

---

### Indentation (Improved)

- `<` → เลื่อนไปซ้าย  
- `>` → เลื่อนไปขวา  

> เยื้องทีละ **1 ช่อง** แทนค่า default (2–4 ช่อง)  
> และยังคง selection ไว้

---

### Comment

- `gcc` → เปิด/ปิด comment (บรรทัด)  
- `gc` → เปิด/ปิด comment (เลือกหลายบรรทัด)

---

### Telescope

- `<Space>f` → ค้นหาไฟล์  
- `:Telescope find_files` → ใช้คำสั่งเอง  

---

## Run Code

กด `<Space>r` เพื่อรันไฟล์หลักของโปรเจค (`app2.py`) ใน terminal

> หมายเหตุ: จะไม่รันไฟล์ปัจจุบัน แต่จะรัน `app2.py` เสมอ

![run_code_preview](run_code_example.jpg)

## Optional: Run Current File (Fallback to app2.py)

หากต้องการให้ `<Space>r` รันไฟล์ปัจจุบันแทน สามารถใช้โค้ดนี้:

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

- ใช้ `Space` เป็น leader key  
- ออกแบบมาให้เร็วและใช้งานง่าย

---

## Plugin Management

```vim
:Lazy update  " อัปเดต plugin
:Lazy clean   " ลบ plugin ที่ไม่ได้ใช้
:Lazy sync    " ติดตั้ง plugin ที่ยังขาด
```

---

## Reset

```bash
rm -rf ~/.local/share/nvim
```

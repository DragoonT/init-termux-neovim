# Minimal Neovim Config (Lazy.nvim)

🌐 [EN](README.md) | [TH](README_th.md) | [JP](README_jp.md) | [CN](README_cn.md) | [KR](README_kr.md)

![preview](init_example.png)

`lazy.nvim` を使用した、VSCode ライクな見た目と操作感の**単一ファイル Neovim 設定**です。

## Features

- プラグインマネージャー: lazy.nvim（自動ブートストラップ）
- VSCode風ダークテーマ（Carbonfox / Nightfox）
- ファイルエクスプローラー: Neo-tree（自動起動、右クリック操作メニュー付き）
- Telescope（ファジーファインダー — Ctrl+P、コマンドパレット）
- LSP + 自動補完（Mason、nvim-cmp、LuaSnip）— IntelliSense 体験
- Treesitter シンタックスハイライト
- Gitサイン + 行内 blame
- ステータスライン（lualine）とタブライン（bufferline）— VSCode スタイル
- 統合ターミナル（toggleterm — Ctrl+\`）
- インライン診断（error-lens + lsp_lines）
- インデントガイド、自動括号補完、which-key ポップアップ
- Discord Rich Presence
- ダッシュボード（alpha-nvim）
- F5 / `<Space>r` で現在のファイルを実行
- Nerd Font アイコン

---

## Requirements

- Neovim >= 0.9
- Git
- Nerd Font（アイコン用・必須）
- Node.js（ts_ls、html、css、json LSP用）
- Python（pyright LSP用）
- Rust / cargo（rust_analyzer LSP用）

---

## Installation

この設定をクローンします：

```bash
git clone https://github.com/DragoonT/init-termux-neovim.git init
```

## Quick Install (Single File)

`init.lua` ファイル1つだけでインストールできます（リポジトリ全体のクローン不要）。

```bash
mkdir -p ~/.config/nvim
[ -f ~/.config/nvim/init.lua ] && cp ~/.config/nvim/init.lua ~/.config/nvim/init.lua.bak
curl -o ~/.config/nvim/init.lua https://raw.githubusercontent.com/DragoonT/init-termux-neovim/main/init.lua
```

Neovimを起動：

```bash
nvim
```

初回起動時にプラグインが自動でインストールされます。

---

## Recommended: Use tmux

TermuxでのUI問題（例：サイドバーが消える）を防ぐため、`tmux` 内でNeovimを実行してください。

```bash
pkg install tmux
tmux
nvim
```

---

## Nerd Font (Required for Icons)

この設定ではアイコンを使用するため、**Nerd Font** が必要です。未インストールの場合、アイコンが四角や壊れた記号になります。

### Termux インストール

```bash
mkdir -p ~/.termux
curl -L -o ~/.termux/font.ttf \
https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf
termux-reload-settings
```

### 推奨フォント

- FiraCode Nerd Font
- JetBrainsMono Nerd Font
- Hack Nerd Font

---

## Theme

この設定では **Carbonfox**（Nightfox より）を使用 — VSCodeのカラーに合わせたダークテーマです。

実行時にテーマを変更：

```vim
:colorscheme carbonfox
:colorscheme nightfox
:Telescope colorscheme
```

---

## ファイルエクスプローラー（Neo-tree）

- 起動時に自動で開く（左サイドバー、幅30）
- ファイル/フォルダ上で `<Space>` を押してアクションメニューを開く：
  - 新しいファイル / 新しいフォルダ
  - 名前変更
  - コピー / カット / ペースト
  - 削除（確認あり）
  - パスをコピー

| キー | アクション |
|------|-----------|
| `<leader>e` / `<C-b>` | Neo-tree 切り替え |
| `<Space>`（ツリー内） | アクションメニューを開く |

---

## LSP & 自動補完

**Mason** で管理。以下の言語サーバーが自動インストールされます：

| 言語 | サーバー |
|------|---------|
| Lua | lua_ls |
| JavaScript / TypeScript | ts_ls |
| Python | pyright |
| CSS | cssls |
| HTML | html |
| JSON | jsonls |
| Rust | rust_analyzer |

### LSP キーバインド

| キー | アクション |
|------|-----------|
| `gd` | 定義へジャンプ |
| `gD` | 宣言へジャンプ |
| `gr` | 参照を表示 |
| `gi` | 実装へジャンプ |
| `K` | ホバードキュメント |
| `<leader>rn` | シンボルの名前変更 |
| `<leader>ca` | コードアクション |
| `<leader>f` | ファイルをフォーマット |
| `[d` / `]d` | 前/次の診断 |
| `<leader>e` | 診断フロートを表示 |

### 自動補完

| キー | アクション |
|------|-----------|
| `<Tab>` | 次の項目 / スニペット展開 |
| `<S-Tab>` | 前の項目 |
| `<CR>` | 選択を確定 |
| `<C-Space>` | 補完をトリガー |
| `<C-e>` | 中止 |

---

## Telescope（ファジーファインダー）

| キー | アクション |
|------|-----------|
| `<C-p>` | ファイル検索 |
| `<C-S-p>` | コマンドパレット |
| `<leader>fg` | ライブ grep |
| `<leader>fb` | バッファ一覧 |
| `<leader>fd` | 診断 |
| `<leader>fr` | 最近のファイル |
| `<leader>ff` | プロジェクト内テキスト検索 |
| `<leader>fa` | ホームの全ファイル検索 |
| `<leader>fs` | 現在のファイルのフォルダから検索 |
| `<leader>th` | カラースキーム一覧 |
| `<leader>vc` | nvim設定内を検索 |

---

## コード実行（F5 / `<Space>r`）

`<F5>`、`<C-F5>`、または `<leader>r` を押すと、**現在のファイル**がターミナルで実行されます。

対応ファイルタイプ：

| ファイルタイプ | 実行方法 |
|--------------|---------|
| Python | `python file.py` |
| JavaScript | `node file.js` |
| TypeScript / TSX | `npx ts-node file.ts` |
| Lua | `lua file.lua` |
| Bash / sh | `bash file.sh` |
| PowerShell | `powershell -File file.ps1` |
| Rust | `cargo run` |
| Go | `go run file.go` |
| C | `gcc` → 出力を実行 |
| C++ | `g++` → 出力を実行 |
| Java | `javac` → `java` |
| PHP | `php file.php` |
| Ruby | `ruby file.rb` |

---

## ターミナル（Toggleterm）

| キー | アクション |
|------|-----------|
| `<C-\`>` | ターミナル切り替え |
| `<leader>t1/t2/t3` | ターミナル 1/2/3 |
| `<Esc>`（ターミナル内） | ノーマルモードへ |

---

## ナビゲーション & 編集

### 保存 / 終了

| キー | アクション |
|------|-----------|
| `<C-s>` | 保存 |
| `<leader>q` / `<C-q>` | 全て終了 |
| `<leader>wq` | 全て保存して終了 |

### アンドゥ / リドゥ

| キー | アクション |
|------|-----------|
| `<C-z>` | アンドゥ |
| `<C-y>` | リドゥ |

### コピー / ペースト / 削除

| キー | アクション |
|------|-----------|
| `y` | コピー（選択を維持） |
| `<C-c>`（ビジュアル） | システムクリップボードへコピー |
| `<C-v>` | システムクリップボードからペースト |
| `<leader>d` | クリップボードに影響しない削除 |
| `d` | カット（削除 + レジスタ保存） |

### その他

| キー | アクション |
|------|-----------|
| `<C-a>` / `<leader>a` | 全選択 |
| `<C-w>` | バッファを閉じる |
| `<A-Up>` / `<A-Down>` | 行を上/下へ移動 |
| `<A-S-Down>` | 行を複製 |
| `<C-/>` | コメントの切り替え |
| `<Tab>` / `<S-Tab>`（ビジュアル） | インデント増/減 |
| `<C-h/j/k/l>` | スプリット間を移動 |
| `<C-Tab>` / `<C-S-Tab>` | 次/前のバッファタブ |
| `<Esc>` | 検索ハイライトをクリア |

---

## Git（Gitsigns）

- 追加 / 変更 / 削除行のガターサイン
- 現在行のインライン git blame（500ms 遅延）
- 形式：`著者, YYYY-MM-DD - コミット概要`

---

## プラグイン管理

```vim
:Lazy update   " プラグインを更新
:Lazy clean    " 未使用プラグインを削除
:Lazy sync     " 不足プラグインをインストール
```

---

## リセット

```bash
rm -rf ~/.local/share/nvim
```

---

## Windows サポート

Windowsでは自動的に：
- PowerShell をシェルとして設定
- `win32yank.exe` でクリップボード連携

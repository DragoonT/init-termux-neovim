local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ─── Leader key (set BEFORE lazy) ───────────────────────────
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- ── Set shell BEFORE lazy so toggleterm picks it up ──────────
if vim.fn.has("win32") == 1 then
  vim.o.shell        = "powershell"
  vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  vim.o.shellxquote  = ""
  vim.o.shellquote   = ""
  vim.o.shellredir   = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  vim.o.shellpipe    = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
end

if vim.fn.has("win32") == 1 then
  vim.g.clipboard = {
    name  = "win32yank",
    copy  = { ["+"] = "win32yank.exe -i --crlf", ["*"] = "win32yank.exe -i --crlf" },
    paste = { ["+"] = "win32yank.exe -o --lf",   ["*"] = "win32yank.exe -o --lf" },
    cache_enabled = 0,
  }
end

require("lazy").setup({

  -- ── 1. NIGHTFOX (VSCode dark theme) ──────────────────────
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nightfox").setup({
        options = {
          compile_path = vim.fn.stdpath("cache") .. "/nightfox",
          compile_file_types = {},
          transparent = false,
          terminal_colors = true,
          dim_inactive = false,
          styles = {
            comments    = "italic",
            conditionals = "NONE",
            constants   = "NONE",
            functions   = "NONE",
            keywords    = "NONE",
            numbers     = "NONE",
            operators   = "NONE",
            strings     = "NONE",
            types       = "italic",
            variables   = "NONE",
          },
        },
        palettes = {
          carbonfox = {
            bg1  = "#1e1e1e",
            bg2  = "#252526",
            bg3  = "#2d2d2d",
            bg4  = "#3c3c3c",
            fg1  = "#d4d4d4",
            sel0 = "#264f78",
            sel1 = "#094771",
          },
        },
        specs = {},
        groups = {
          carbonfox = {
            ["@keyword"]            = { fg = "#569cd6" },
            ["@keyword.function"]   = { fg = "#569cd6" },
            ["@keyword.return"]     = { fg = "#c586c0" },
            ["@string"]             = { fg = "#ce9178" },
            ["@number"]             = { fg = "#b5cea8" },
            ["@boolean"]            = { fg = "#569cd6" },
            ["@type"]               = { fg = "#4ec9b0" },
            ["@type.builtin"]       = { fg = "#569cd6" },
            ["@variable"]           = { fg = "#9cdcfe" },
            ["@variable.builtin"]   = { fg = "#9cdcfe" },
            ["@function"]           = { fg = "#dcdcaa" },
            ["@function.builtin"]   = { fg = "#dcdcaa" },
            ["@function.call"]      = { fg = "#dcdcaa" },
            ["@method"]             = { fg = "#dcdcaa" },
            ["@method.call"]        = { fg = "#dcdcaa" },
            ["@parameter"]          = { fg = "#9cdcfe" },
            ["@property"]           = { fg = "#9cdcfe" },
            ["@field"]              = { fg = "#9cdcfe" },
            ["@comment"]            = { fg = "#6a9955", style = "italic" },
            ["@punctuation"]        = { fg = "#d4d4d4" },
            ["@operator"]           = { fg = "#d4d4d4" },
            ["@constant"]           = { fg = "#4fc1ff" },
            ["@namespace"]          = { fg = "#4ec9b0" },
            ["@tag"]                = { fg = "#569cd6" },
            ["@tag.attribute"]      = { fg = "#9cdcfe" },
            ["@tag.delimiter"]      = { fg = "#808080" },
            LineNr                  = { fg = "#858585" },
            CursorLineNr            = { fg = "#c6c6c6" },
            CursorLine              = { bg = "#2a2a2a" },
            Visual                  = { bg = "#264f78" },
            Pmenu                   = { bg = "#252526", fg = "#d4d4d4" },
            PmenuSel                = { bg = "#094771", fg = "#ffffff" },
            PmenuSbar               = { bg = "#3c3c3c" },
            PmenuThumb              = { bg = "#757575" },
            StatusLine              = { bg = "#007acc", fg = "#ffffff" },
            StatusLineNC            = { bg = "#3c3c3c", fg = "#cccccc" },
            TabLine                 = { bg = "#2d2d2d", fg = "#969696" },
            TabLineSel              = { bg = "#1e1e1e", fg = "#ffffff" },
            TabLineFill             = { bg = "#2d2d2d" },
            NormalFloat             = { bg = "#252526" },
            FloatBorder             = { bg = "#252526", fg = "#454545" },
            WinSeparator            = { fg = "#444444" },
          },
        },
      })
      vim.cmd("colorscheme carbonfox")
    end,
  },

  -- ── 2. BETTER COMMENTS ───────────────────────────────────
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPost",
    opts = {
      signs      = true,
      sign_priority = 8,
      keywords = {
        FIX  = { icon = " ", color = "error",   alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = "󰅒 ",                   alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = "󰍩 ", color = "hint",   alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test",   alt = { "TESTING", "PASSED", "FAILED" } },
      },
      colors = {
        error   = { "DiagnosticError",   "#f44747" },
        warning = { "DiagnosticWarn",    "#ff8c00" },
        info    = { "DiagnosticInfo",    "#3794ff" },
        hint    = { "DiagnosticHint",    "#4ec9b0" },
        test    = { "#89ddff" },
        default = { "#7c3aed" },
      },
    },
  },

  {
    "numToStr/Comment.nvim",
    event = "BufReadPost",
    opts = {},
  },

  {
    "folke/paint.nvim",
    event = "BufReadPost",
    config = function()
      require("paint").setup({
        highlights = {
          { filter = {}, pattern = "%s*(.-)%s*!%s+(.+)", hl = "DiagnosticError" },
          { filter = {}, pattern = "%s*(.-)%s*%?%s+(.+)", hl = "DiagnosticHint" },
          { filter = {}, pattern = "%s*(.-)%s*%*%s+(.+)", hl = "DiagnosticWarn" },
          { filter = {}, pattern = "%s*(.-)%s*TODO%s*:?%s*(.+)", hl = "TodoCommentTodo" },
        },
      })
    end,
  },

  -- ── 3. DISCORD PRESENCE ──────────────────────────────────
  {
    "vyfor/cord.nvim",
    build = ":Cord update",
    event = "VeryLazy",
    opts = {
      usercmds        = true,
      timer           = {
        interval        = 1500,
        reset_on_idle   = false,
        reset_on_change = false,
      },
      editor          = {
        client        = "neovim",
        tooltip       = "The One True Editor",
      },
      display         = {
        show_time       = true,
        show_repository = true,
      },
      lsp             = {
        show_problem_count = true,
      },
      buttons         = {
        { label = "View on GitHub", url = "https://github.com" },
      },
    },
  },

  -- ── 4. ERROR LENS (inline diagnostics) ───────────────────
  {
    "chikko80/error-lens.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("error-lens").setup({
        enabled = true,
        auto_adjust = {
          enable        = false,
          fallback_bg   = "#1e1e1e",
          step          = 7,
          total         = 30,
        },
        prefix   = 4,
        colors = {
          error_fg   = "#f44747",
          error_bg   = "#4b1818",
          warn_fg    = "#ff8c00",
          warn_bg    = "#4b3400",
          info_fg    = "#3794ff",
          info_bg    = "#1b3a5c",
          hint_fg    = "#4ec9b0",
          hint_bg    = "#1b3a36",
        },
      })
    end,
  },

  {
    "ErichDonGubler/lsp_lines.nvim",
    event = "LspAttach",
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config({
        virtual_text  = false,
        virtual_lines = { only_current_line = true },
        signs         = true,
        underline     = true,
        update_in_insert = false,
        severity_sort = true,
      })
    end,
  },

  -- ── 5. FILE ICONS ────────────────────────────────────────
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    config = function()
      require("nvim-web-devicons").setup({
        override = {},
        color_icons = true,
        default = true,
      })
    end,
  },

  -- ── 5b. NEO-TREE (file explorer) ─────────────────────────
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      local clipboard = { files = {}, mode = nil }

      vim.api.nvim_set_hl(0, "NeoTreeNormal",        { bg = "#252526", fg = "#cccccc" })
      vim.api.nvim_set_hl(0, "NeoTreeNormalNC",      { bg = "#252526", fg = "#cccccc" })
      vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer",   { bg = "#252526", fg = "#252526" })
      vim.api.nvim_set_hl(0, "NeoTreeWinSeparator",  { bg = "#252526", fg = "#444444" })
      vim.api.nvim_set_hl(0, "NeoTreeRootName",      { fg = "#cccccc", bold = true })
      vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = "#e8c07d" })
      vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = "#dcb67a" })
      vim.api.nvim_set_hl(0, "NeoTreeGitModified",   { fg = "#e2c08d" })
      vim.api.nvim_set_hl(0, "NeoTreeGitAdded",      { fg = "#81b88b" })
      vim.api.nvim_set_hl(0, "NeoTreeGitUntracked",  { fg = "#73c991" })
      vim.api.nvim_set_hl(0, "NeoTreeGitDeleted",    { fg = "#c74e39" })
      vim.api.nvim_set_hl(0, "NeoTreeCursorLine",    { bg = "#094771" })

      require("neo-tree").setup({
        close_if_last_window = false,
        popup_border_style   = "rounded",
        enable_git_status    = true,
        enable_diagnostics   = true,

        default_component_configs = {
          indent = {
            indent_size   = 2,
            padding       = 1,
            with_markers  = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight     = "NeoTreeIndentMarker",
            with_expanders = true,
            expander_collapsed = ">",
            expander_expanded  = "v",
          },
          icon = {
            folder_closed = "",
            folder_open   = "",
            folder_empty  = "",
            default       = "",
          },
          modified = {
            symbol    = "*",
            highlight = "NeoTreeModified",
          },
          name = {
            trailing_slash = false,
            use_git_status_colors = true,
          },
          git_status = {
            symbols = {
              added     = "A",
              modified  = "M",
              deleted   = "D",
              renamed   = "R",
              untracked = "U",
              ignored   = "!",
              unstaged  = "M",
              staged    = "A",
              conflict  = "C",
            },
          },
        },

        filesystem = {
          filtered_items = {
            hide_dotfiles    = false,
            hide_gitignored  = false,
            hide_hidden      = false,
            never_show       = { ".DS_Store" },
          },
          follow_current_file = {
            enabled = true,
          },
          use_libuv_file_watcher = true,
          bind_to_cwd = true,
        },

        window = {
          position = "left",
          width    = 30,
          mappings = {
            ["<space>"] = function(state)
              local cmds = require("neo-tree.sources.filesystem.commands")
              local node  = state.tree:get_node()

              local function get_path()
                return node:get_id()
              end

              vim.ui.select({
                "New file",
                "New folder",
                "Rename",
                "Copy",
                "Cut",
                "Paste",
                "Delete",
                "Copy path",
                "Clear clipboard",
              }, {
                prompt = "File actions:",
              }, function(choice)
                if not choice then return end

                if choice == "New file" then
                  cmds.add(state)
                  vim.schedule(function()
                    vim.cmd("startinsert")
                  end)

                elseif choice == "New folder" then
                  cmds.add_directory(state)

                elseif choice == "Rename" then
                  cmds.rename(state)

                elseif choice == "Copy" then
                  local n = state.tree:get_node()
                  if n then
                    clipboard.mode = "copy"
                    local path = n:get_id()
                    if not vim.tbl_contains(clipboard.files, path) then
                      table.insert(clipboard.files, path)
                    end
                    print("Added to copy buffer: " .. n.name)
                  end

                elseif choice == "Cut" then
                  local n = state.tree:get_node()
                  if n then
                    clipboard.mode = "cut"
                    local path = n:get_id()
                    if not vim.tbl_contains(clipboard.files, path) then
                      table.insert(clipboard.files, path)
                    end
                    print("Added to move buffer: " .. n.name)
                  end

                elseif choice == "Paste" then
                  local target = state.tree:get_node()
                  if not target or target.type ~= "directory" then
                    print("Select a destination folder first")
                    return
                  end
                  for _, src in ipairs(clipboard.files) do
                    local name = vim.fn.fnamemodify(src, ":t")
                    local dst  = target:get_id() .. "/" .. name
                    if clipboard.mode == "copy" then
                      vim.fn.system({ "cp", "-R", src, dst })
                    elseif clipboard.mode == "cut" then
                      vim.loop.fs_rename(src, dst)
                    end
                  end
                  if clipboard.mode == "cut" then
                    clipboard.files = {}
                  end
                  require("neo-tree.sources.manager").refresh("filesystem")

                elseif choice == "Clear clipboard" then
                  clipboard.files = {}
                  clipboard.mode  = nil
                  print("Clipboard cleared")

                elseif choice == "Delete" then
                  vim.ui.select({ "No", "Yes" }, {
                    prompt = "Delete this?",
                  }, function(confirm)
                    if confirm ~= "Yes" then return end
                    local n = state.tree:get_node()
                    if not n then return end
                    local path = n:get_id()
                    if not path then return end

                    local function delete_recursive(p)
                      local stat = vim.loop.fs_stat(p)
                      if not stat then return end
                      if stat.type == "file" then
                        vim.loop.fs_unlink(p)
                      elseif stat.type == "directory" then
                        local handle = vim.loop.fs_scandir(p)
                        if handle then
                          while true do
                            local name = vim.loop.fs_scandir_next(handle)
                            if not name then break end
                            delete_recursive(p .. "/" .. name)
                          end
                        end
                        vim.loop.fs_rmdir(p)
                      end
                    end

                    delete_recursive(path)
                    require("neo-tree.sources.manager").refresh("filesystem")
                  end)

                elseif choice == "Copy path" then
                  local path = get_path()
                  vim.fn.setreg("+", path)
                  print("Copied: " .. path)
                end
              end)
            end,
          },
        },
      })

      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          require("neo-tree.command").execute({ action = "show" })
        end,
      })
    end,
  },

  -- ── 6. HEADWIND (Tailwind CSS class sorter) ──────────────
  {
    "steelsojka/headwind.nvim",
    ft = { "html", "css", "javascriptreact", "typescriptreact", "vue", "svelte", "astro" },
    config = function()
      require("headwind").setup({
        use_treesitter = true,
        run_on_save    = true,
      })
    end,
  },

  -- ── 7. LSP + AUTOCOMPLETE ────────────────────────────────
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed   = "✓",
            package_pending     = "➜",
            package_uninstalled = "✗",
          },
        },
      })
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", "ts_ls", "pyright", "cssls", "html",
          "jsonls", "rust_analyzer",
        },
        automatic_installation = true,
      })

      local cmp      = require("cmp")
      local luasnip  = require("luasnip")
      local lspkind  = require("lspkind")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        window = {
          completion    = cmp.config.window.bordered({ border = "rounded", winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,Search:None" }),
          documentation = cmp.config.window.bordered({ border = "rounded" }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]     = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"]   = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode      = "symbol_text",
            maxwidth  = 50,
            ellipsis_char = "...",
            symbol_map = {
              Text          = "󰉿",
              Method        = "󰆧",
              Function      = "󰊕",
              Constructor   = "",
              Field         = "󰜢",
              Variable      = "󰀫",
              Class         = "󰠱",
              Interface     = "",
              Module        = "",
              Property      = "󰜢",
              Unit          = "󰑭",
              Value         = "󰎠",
              Enum          = "",
              Keyword       = "󰌋",
              Snippet       = "",
              Color         = "󰏘",
              File          = "󰈙",
              Reference     = "󰈇",
              Folder        = "󰉋",
              EnumMember    = "",
              Constant      = "󰏿",
              Struct        = "󰙅",
              Event         = "",
              Operator      = "󰆕",
              TypeParameter = "",
            },
          }),
        },
      })

      local on_attach = function(_, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end
        map("gd",         vim.lsp.buf.definition,       "Go to Definition")
        map("gD",         vim.lsp.buf.declaration,      "Go to Declaration")
        map("gr",         vim.lsp.buf.references,       "Go to References")
        map("gi",         vim.lsp.buf.implementation,   "Go to Implementation")
        map("K",          vim.lsp.buf.hover,            "Hover Docs")
        map("<leader>rn", vim.lsp.buf.rename,           "Rename Symbol")
        map("<leader>ca", vim.lsp.buf.code_action,      "Code Action")
        map("<leader>f",  vim.lsp.buf.format,           "Format File")
        map("[d",         vim.diagnostic.goto_prev,     "Prev Diagnostic")
        map("]d",         vim.diagnostic.goto_next,     "Next Diagnostic")
        map("<leader>e",  vim.diagnostic.open_float,    "Show Diagnostic")
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      local base_config = {
        on_attach    = on_attach,
        capabilities = capabilities,
      }

      for _, server in ipairs({ "ts_ls", "pyright", "cssls", "html", "jsonls", "rust_analyzer" }) do
        vim.lsp.config(server, base_config)
        vim.lsp.enable(server)
      end

      vim.lsp.config("lua_ls", vim.tbl_deep_extend("force", base_config, {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace   = { checkThirdParty = false },
            telemetry   = { enable = false },
          },
        },
      }))
      vim.lsp.enable("lua_ls")
    end,
  },

  -- ── 8. TREESITTER ────────────────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    build   = ":TSUpdate",
    event   = "BufReadPost",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
    },
    opts = {
      ensure_installed = {
        "lua", "vim", "vimdoc", "javascript", "typescript",
        "tsx", "python", "rust", "html", "css", "json",
        "yaml", "markdown", "bash", "c", "cpp",
      },
      auto_install  = true,
      highlight     = { enable = true },
      indent        = { enable = true },
      textobjects = {
        select = {
          enable    = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
      local ok, autotag = pcall(require, "nvim-ts-autotag")
      if ok then autotag.setup() end
    end,
  },

  -- ── 9. STATUSLINE ────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      local vscode_theme = {
        normal = {
          a = { bg = "#007acc", fg = "#ffffff", gui = "bold" },
          b = { bg = "#3c3c3c", fg = "#cccccc" },
          c = { bg = "#252526", fg = "#cccccc" },
        },
        insert  = { a = { bg = "#c586c0", fg = "#ffffff", gui = "bold" } },
        visual  = { a = { bg = "#264f78", fg = "#ffffff", gui = "bold" } },
        replace = { a = { bg = "#f44747", fg = "#ffffff", gui = "bold" } },
        inactive = {
          a = { bg = "#3c3c3c", fg = "#969696" },
          b = { bg = "#3c3c3c", fg = "#969696" },
          c = { bg = "#252526", fg = "#969696" },
        },
      }
      require("lualine").setup({
        options = {
          theme            = vscode_theme,
          component_separators = { left = "", right = "" },
          section_separators  = { left = "", right = "" },
          globalstatus     = true,
          icons_enabled    = false,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- ── 10. TABLINE ──────────────────────────────────────────
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      require("bufferline").setup({
        options = {
          mode              = "buffers",
          separator_style   = "thin",
          show_buffer_close_icons = false,
          show_close_icon         = false,
          color_icons       = false,
          diagnostics       = "nvim_lsp",
          diagnostics_indicator = function(count, level)
            local icon = level:match("error") and "E" or "W"
            return " " .. icon .. count
          end,
          offsets = {
            { filetype = "neo-tree", text = "Explorer", highlight = "Directory", separator = true },
          },
        },
        highlights = {
          background        = { bg = "#2d2d2d", fg = "#969696" },
          buffer_selected   = { bg = "#1e1e1e", fg = "#ffffff", bold = true },
          tab_selected      = { bg = "#1e1e1e", fg = "#ffffff" },
          separator         = { bg = "#2d2d2d", fg = "#444444" },
          indicator_selected = { bg = "#1e1e1e", fg = "#007acc" },
        },
      })
    end,
  },

  -- ── 11. TELESCOPE ────────────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build" },
    },
    cmd = "Telescope",
    keys = {
      { "<C-p>",      "<cmd>Telescope find_files<cr>",  desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",   desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",     desc = "Buffers" },
      { "<C-S-p>",    "<cmd>Telescope commands<cr>",    desc = "Command Palette" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          prompt_prefix   = "  ",
          selection_caret = "  ",
          layout_config   = { prompt_position = "top" },
          sorting_strategy = "ascending",
          winblend        = 0,
          borderchars     = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        },
      })
      pcall(require("telescope").load_extension, "fzf")
    end,
  },

  -- ── 12. GIT SIGNS ────────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "▎" },
          change       = { text = "▎" },
          delete       = { text = "" },
          topdelete    = { text = "" },
          changedelete = { text = "▎" },
          untracked    = { text = "▎" },
        },
        current_line_blame = true,
        current_line_blame_opts = {
          delay        = 500,
          virt_text_pos = "eol",
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      })
    end,
  },

  -- ── 13. INDENT GUIDES ────────────────────────────────────
  {
    "lukas-reineke/indent-blankline.nvim",
    main  = "ibl",
    event = "BufReadPost",
    config = function()
      require("ibl").setup({
        indent  = { char = "│", highlight = "IblIndent" },
        scope   = { char = "│", highlight = "IblScope", show_start = true },
      })
      vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3b3b3b" })
      vim.api.nvim_set_hl(0, "IblScope",  { fg = "#5a5a5a" })
    end,
  },

  -- ── 14. AUTO PAIRS ───────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local ap  = require("nvim-autopairs")
      local cmp = require("cmp")
      ap.setup({ check_ts = true })
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- ── 15. WHICH-KEY ────────────────────────────────────────
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts  = {
      plugins = { spelling = true },
      win     = { border = "rounded" },
    },
  },

  -- ── 16. NOTIFY ───────────────────────────────────────────
  {
    "rcarriga/nvim-notify",
    event  = "VeryLazy",
    config = function()
      require("notify").setup({
        background_colour = "#1e1e1e",
        fps               = 30,
        render            = "default",
        stages            = "fade",
        timeout           = 3000,
      })
      vim.notify = require("notify")
    end,
  },

  -- ── 17. NOICE (disabled on Windows) ──────────────────────
  {
    "folke/noice.nvim",
    enabled = false,
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
  },

  -- ── 18. TERMINAL ─────────────────────────────────────────
  {
    "akinsho/toggleterm.nvim",
    lazy  = false,
    config = function()
      require("toggleterm").setup({
        size         = 15,
        open_mapping = [[<C-t>]],
        direction    = "horizontal",
        shade_terminals  = true,
        shell        = vim.o.shell,
        float_opts   = { border = "curved" },
        start_in_insert  = true,
        close_on_exit    = false,
        persist_size     = true,
        persist_mode     = true,
      })

      vim.api.nvim_create_autocmd("TermOpen", {
        pattern  = "term://*toggleterm*",
        callback = function()
          local opts = { buffer = 0 }
          vim.keymap.set("t", "<Esc>",  [[<C-\><C-n>]],        opts)
          vim.keymap.set("t", "<C-t>",  "<cmd>ToggleTerm<cr>", opts)
          vim.keymap.set("t", "<C-h>",  [[<C-\><C-n><C-w>h]], opts)
          vim.keymap.set("t", "<C-j>",  [[<C-\><C-n><C-w>j]], opts)
          vim.keymap.set("t", "<C-k>",  [[<C-\><C-n><C-w>k]], opts)
          vim.keymap.set("t", "<C-l>",  [[<C-\><C-n><C-w>l]], opts)
        end,
      })
    end,
  },

  -- ── 19. DASHBOARD ────────────────────────────────────────
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter",
    config = function()
      local alpha     = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "                                                     ",
      }
      dashboard.section.buttons.val = {
        dashboard.button("e",  "  New file",        "<cmd>ene <BAR> startinsert<cr>"),
        dashboard.button("f",  "  Find file",       "<cmd>Telescope find_files<cr>"),
        dashboard.button("r",  "  Recent files",    "<cmd>Telescope oldfiles<cr>"),
        dashboard.button("g",  "  Find text",       "<cmd>Telescope live_grep<cr>"),
        dashboard.button("c",  "  Config",          "<cmd>e $MYVIMRC<cr>"),
        dashboard.button("q",  "  Quit",            "<cmd>qa<cr>"),
      }
      alpha.setup(dashboard.opts)
    end,
  },

  -- ── 20. SCROLLBAR ────────────────────────────────────────
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    config = function()
      require("scrollbar").setup({
        show = true,
        set_highlights = true,
        folds = 1000,
        max_lines = false,
        handle = {
          text = " ",
          color = "#6b6b6b",
          hide_if_all_visible = true,
        },
        marks = {
          Search  = { color = "#d7ba7d" },
          Error   = { color = "#f44747" },
          Warn    = { color = "#ff8c00" },
          Info    = { color = "#3794ff" },
          Hint    = { color = "#4ec9b0" },
          Misc    = { color = "#c586c0" },
        },
        handlers = {
          cursor      = true,
          diagnostic  = true,
          gitsigns    = true,
          search      = false,
        },
        excluded_filetypes = {
          "neo-tree",
          "alpha",
          "toggleterm",
        },
      })
      vim.api.nvim_set_hl(0, "ScrollbarHandle", { bg = "#6b6b6b" })
    end,
  },

}, {
  ui = {
    border = "rounded",
    icons = {
      cmd    = " ", config = "", event = "",
      ft     = " ", init  = " ", import = " ",
      keys   = " ", lazy  = "󰒲 ", loaded = "●",
      not_loaded = "○", plugin = " ", runtime = " ",
      require = "󰢱 ", source = " ", start  = "",
      task   = "✔ ", list = { "●", "➜", "★", "‒" },
    },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "netrwPlugin",
        "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },
})

-- ─── OPTIONS ────────────────────────────────────────────────
local opt = vim.opt

opt.number         = true
opt.relativenumber = false
opt.cursorline     = true
opt.signcolumn     = "yes"
opt.colorcolumn    = ""
opt.scrolloff      = 8
opt.sidescrolloff  = 8
opt.wrap           = true
opt.linebreak      = true
opt.breakindent    = true
opt.termguicolors  = true
opt.laststatus     = 3
opt.showmode       = false
opt.cmdheight      = 1
opt.pumheight      = 10
opt.shortmess:append("sWcCI")

opt.tabstop        = 4
opt.shiftwidth     = 4
opt.expandtab      = true
opt.smartindent    = true
opt.autoindent     = true

opt.hlsearch       = true
opt.incsearch      = true
opt.ignorecase     = true
opt.smartcase      = true

opt.encoding       = "utf-8"
opt.fileencoding   = "utf-8"
opt.undofile       = true
opt.swapfile       = false
opt.backup         = false
opt.undodir        = vim.fn.stdpath("data") .. "/undo"

opt.splitright     = true
opt.splitbelow     = true

opt.updatetime     = 250
opt.timeoutlen     = 300
opt.redrawtime     = 10000

opt.clipboard      = "unnamedplus"
opt.mouse          = "a"

opt.foldmethod     = "expr"
opt.foldexpr       = "nvim_treesitter#foldexpr()"
opt.foldlevel      = 99

-- ─── KEYMAPS ────────────────────────────────────────────────
local map = vim.keymap.set

-- ── SAVE ─────────────────────────────────────────────────────
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save" })

-- ── QUIT ─────────────────────────────────────────────────────
map("n", "<leader>q",  "<cmd>qall!<cr>",  { desc = "Quit all" })
map("n", "<C-q>",      "<cmd>qall!<cr>",  { desc = "Quit all" })
map("n", "<leader>wq", "<cmd>wqa<cr>",    { desc = "Save all and quit" })

-- ── UNDO / REDO ───────────────────────────────────────────────
map("n", "<C-z>", "u",     { desc = "Undo" })
map("n", "<C-y>", "<C-r>", { desc = "Redo" })

-- ── COPY / PASTE / DELETE ─────────────────────────────────────
map("v", "y", "ygv<Esc>", { noremap = true, desc = "Copy (stay in place)" })
map("v", "<C-c>", '"+y',   { desc = "Copy to clipboard" })
map("n", "<C-v>", '"+p',   { desc = "Paste from clipboard" })
map("i", "<C-v>", '<C-r>+', { desc = "Paste from clipboard (insert)" })
map("n", "<leader>d", '"_d',  { noremap = true, desc = "Delete (no yank)" })
map("v", "<leader>d", '"_d',  { noremap = true, desc = "Delete (no yank)" })

-- ── SELECT ALL ────────────────────────────────────────────────
map("n", "<C-a>",     "ggVG", { desc = "Select all" })
map("n", "<leader>a", "ggVG", { desc = "Select all" })

-- ── CLOSE BUFFER ─────────────────────────────────────────────
map("n", "<C-w>", "<cmd>bd<cr>", { desc = "Close buffer" })

-- ── FILE EXPLORER ────────────────────────────────────────────
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle Explorer" })
map("n", "<C-b>",     "<cmd>Neotree toggle<cr>", { desc = "Toggle Explorer" })

-- ── SEARCH (Telescope) ────────────────────────────────────────
map("n", "<leader>f", function()
  require("telescope.builtin").current_buffer_fuzzy_find({ previewer = false })
end, { desc = "Find in current file" })

map("n", "<leader>ff", function()
  require("telescope.builtin").live_grep()
end, { desc = "Find text in project" })

map("n", "<leader>fa", function()
  require("telescope.builtin").find_files({
    search_dirs = { vim.fn.expand("~") },
    hidden      = true,
    no_ignore   = true,
    prompt_title = "Find All Files (Home)",
  })
end, { desc = "Find all files on PC" })

map("n", "<leader>fs", function()
  local current_file = vim.fn.expand("%:p")
  local dir
  if current_file == "" then
    dir = vim.fn.getcwd()
  else
    dir = vim.fn.fnamemodify(current_file, ":h")
  end
  require("telescope.builtin").find_files({
    cwd          = dir,
    hidden       = true,
    prompt_title = "Files in: " .. vim.fn.fnamemodify(dir, ":~"),
  })
end, { desc = "Find files from current file's folder" })

map("n", "<leader>fr", require("telescope.builtin").oldfiles, { desc = "Recent files" })
map("n", "<C-p>",      "<cmd>Telescope find_files<cr>",       { desc = "Find files" })
map("n", "<C-S-p>",    "<cmd>Telescope commands<cr>",         { desc = "Command palette" })
map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>",      { desc = "Diagnostics" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",        { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>",          { desc = "Buffers" })
map("n", "<leader>th", "<cmd>Telescope colorscheme<cr>",      { desc = "Colorscheme" })

map("n", "<leader>vc", function()
  require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find in nvim config" })

-- ── MOVE LINES ────────────────────────────────────────────────
map("n", "<A-Up>",   "<cmd>m .-2<cr>==",  { desc = "Move line up" })
map("n", "<A-Down>", "<cmd>m .+1<cr>==",  { desc = "Move line down" })
map("v", "<A-Up>",   ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
map("v", "<A-Down>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })

-- ── DUPLICATE LINE ────────────────────────────────────────────
map("n", "<A-S-Down>", "<cmd>t.<cr>", { desc = "Duplicate line" })

-- ── COMMENT TOGGLE ───────────────────────────────────────────
map("n", "<C-/>", "gcc", { remap = true, desc = "Toggle comment" })
map("v", "<C-/>", "gc",  { remap = true, desc = "Toggle comment (visual)" })

-- ── INDENT / DE-INDENT ───────────────────────────────────────
map("v", "<Tab>",   ">gv", { noremap = true, desc = "Indent" })
map("v", "<S-Tab>", "<gv", { noremap = true, desc = "De-indent" })

-- ── SPLIT NAVIGATION ─────────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- ── BUFFER / TAB NAVIGATION ──────────────────────────────────
map("n", "<C-Tab>",   "<cmd>BufferLineCycleNext<cr>", { desc = "Next tab" })
map("n", "<C-S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev tab" })

-- ── TERMINAL ─────────────────────────────────────────────────
map("n", "<leader>t1", "<cmd>1ToggleTerm<cr>", { desc = "Terminal 1" })
map("n", "<leader>t2", "<cmd>2ToggleTerm<cr>", { desc = "Terminal 2" })
map("n", "<leader>t3", "<cmd>3ToggleTerm<cr>", { desc = "Terminal 3" })
map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",      { desc = "Float terminal" })
map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>",   { desc = "Vertical terminal" })
map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Horizontal terminal" })

-- ── RUN CODE ─────────────────────────────────────────────────
local function run_code()
  vim.cmd("write")

  local ft     = vim.bo.filetype
  local file   = vim.fn.expand("%:p")
  local fname  = vim.fn.expand("%:t")
  local fdir   = vim.fn.expand("%:p:h")
  local fnoext = vim.fn.expand("%:p:r")

  local cmd = nil

  if ft == "python" then
    cmd = "python " .. vim.fn.shellescape(file)
  elseif ft == "javascript" then
    cmd = "node " .. vim.fn.shellescape(file)
  elseif ft == "typescript" or ft == "typescriptreact" then
    cmd = "npx ts-node " .. vim.fn.shellescape(file)
  elseif ft == "javascriptreact" then
    cmd = "node " .. vim.fn.shellescape(file)
  elseif ft == "lua" then
    cmd = "lua " .. vim.fn.shellescape(file)
  elseif ft == "sh" or ft == "bash" then
    cmd = "bash " .. vim.fn.shellescape(file)
  elseif ft == "ps1" then
    cmd = "powershell -ExecutionPolicy Bypass -File " .. vim.fn.shellescape(file)
  elseif ft == "rust" then
    cmd = "cargo run"
  elseif ft == "go" then
    cmd = "go run " .. vim.fn.shellescape(file)
  elseif ft == "c" then
    local out = fnoext .. ".out"
    cmd = "gcc " .. vim.fn.shellescape(file) .. " -o " .. vim.fn.shellescape(out)
        .. " && " .. vim.fn.shellescape(out)
  elseif ft == "cpp" then
    local out = fnoext .. ".out"
    cmd = "g++ " .. vim.fn.shellescape(file) .. " -o " .. vim.fn.shellescape(out)
        .. " && " .. vim.fn.shellescape(out)
  elseif ft == "java" then
    cmd = "javac " .. vim.fn.shellescape(file)
        .. " && java -cp " .. vim.fn.shellescape(fdir)
        .. " " .. vim.fn.fnamemodify(fname, ":r")
  elseif ft == "php" then
    cmd = "php " .. vim.fn.shellescape(file)
  elseif ft == "ruby" then
    cmd = "ruby " .. vim.fn.shellescape(file)
  else
    vim.notify("No runner configured for: " .. ft, vim.log.levels.WARN)
    return
  end

  local Terminal = require("toggleterm.terminal").Terminal
  local runner = Terminal:new({
    cmd           = cmd,
    direction     = "horizontal",
    close_on_exit = false,
    on_open = function()
      vim.cmd("startinsert!")
    end,
  })
  runner:toggle()
end

map("n", "<F5>",      run_code, { desc = "Run current file" })
map("n", "<C-F5>",    run_code, { desc = "Run current file" })
map("n", "<leader>r", run_code, { desc = "Run current file" })

-- ── CLEAR SEARCH HIGHLIGHT ───────────────────────────────────
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- ─── AUTOCMDS ───────────────────────────────────────────────
vim.api.nvim_create_autocmd("TextYankPost", {
  group    = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function() vim.highlight.on_yank({ higroup = "Visual", timeout = 200 }) end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group    = vim.api.nvim_create_augroup("trim_whitespace", { clear = true }),
  pattern  = "*",
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group    = vim.api.nvim_create_augroup("format_on_save", { clear = true }),
  callback = function()
    if not vim.bo.modifiable then return end
    if vim.lsp.buf.server_ready and vim.lsp.buf.server_ready() then
      vim.lsp.buf.format({ async = false })
    end
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group    = vim.api.nvim_create_augroup("restore_cursor", { clear = true }),
  callback = function()
    local mark   = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ── AUTO RELOAD FILE WHEN CHANGED OUTSIDE NEOVIM ────────────
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group    = vim.api.nvim_create_augroup("auto_reload", { clear = true }),
  callback = function()
    if vim.fn.mode() ~= "c" and vim.fn.bufname("%") ~= "" then
      vim.cmd("checktime")
    end
  end,
})
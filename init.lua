local is_windows = vim.fn.has("win32") == 1
local is_linux = vim.fn.has("unix") == 1 and not is_windows

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local theme_file = vim.fn.stdpath("config") .. "/theme.txt"
local created_dirs = {}

local function smart_open(path)
  if not path then return end
  path = vim.fn.fnamemodify(path, ":p")

  if is_windows then
    vim.fn.jobstart({ "cmd", "/c", "start", "", path }, { detach = true })
  else
    vim.cmd("edit " .. vim.fn.fnameescape(path))
  end
end

local function smart_find(cwd)
  require("telescope.builtin").find_files({
    cwd = cwd,
    hidden = true,
    no_ignore = true,

    attach_mappings = function(_, map)
      local actions = require("telescope.actions")
      local state = require("telescope.actions.state")

      local function open_selected(prompt_bufnr)
        local entry = state.get_selected_entry()
        actions.close(prompt_bufnr)
        smart_open(entry.path)
      end

      map("i", "<CR>", open_selected)
      map("n", "<CR>", open_selected)

      return true
    end
  })
end

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "https://github.com/folke/lazy.nvim",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "numToStr/Comment.nvim", config = true },
  { "stevearc/dressing.nvim", opts = {} },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
  },

  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = { "markdown" },
  },

  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  { "folke/tokyonight.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "EdenEast/nightfox.nvim" },
  { "navarasu/onedark.nvim" },
  { "ellisonleao/gruvbox.nvim" },
  { "rebelot/kanagawa.nvim" }
})

require("neo-tree").setup({
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
    },
  },
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("neo-tree.command").execute({ toggle = true })
  end
})

local file = io.open(theme_file, "r")
if file then
  local theme = file:read("*l")
  file:close()
  if theme then
    if theme:match("onedark:") then
      local style = theme:match(":(.+)")
      require("onedark").setup({ style = style })
      require("onedark").load()
    else
      vim.cmd("colorscheme " .. theme)
    end
  end
end

vim.api.nvim_create_user_command("OneDark", function(opts)
  local style = opts.args
  require("onedark").setup({ style = style })
  require("onedark").load()

  local f = io.open(theme_file, "w")
  if f then
    f:write("onedark:" .. style)
    f:close()
  end
end, { nargs = 1 })

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>")

vim.keymap.set("n", "<leader>vc", function()
  require("telescope.builtin").find_files({
    cwd = vim.fn.stdpath("config"),
  })
end)

vim.keymap.set("n", "<leader>f", function()
  require("telescope.builtin").current_buffer_fuzzy_find({
    previewer = false,
  })
end)

vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").live_grep()
end)

vim.keymap.set("n", "<leader>fa", function()
  smart_find(vim.loop.os_homedir())
end)

vim.keymap.set("n", "<leader>fs", function()
  if is_windows then
    smart_find("C:/")
  else
    smart_find("/")
  end
end)

vim.keymap.set("n", "<leader>r", function()
  vim.cmd("w")
  if is_windows then
    vim.cmd("terminal python app2.py")
  else
    vim.cmd("terminal python3 app2.py")
  end
end)

vim.keymap.set("n", "<leader>q", ":qall!<CR>")
vim.keymap.set("n", "<C-q>", ":qall!<CR>")

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.wrap = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

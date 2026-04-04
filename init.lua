-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local theme_file = vim.fn.stdpath("config") .. "/theme.txt"
local file = io.open(theme_file, "r")
local term_buf = nil

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "https://github.com/folke/lazy.nvim",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- plugins
require("lazy").setup({
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = {
          side = "left",
          width = 30,
        },
        renderer = {
          highlight_git = false,
          icons = {
            show = {
              git = false,
            },
          },
        },
      })
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = { "markdown" },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  { "folke/tokyonight.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "EdenEast/nightfox.nvim" },
  { "navarasu/onedark.nvim" },
  { "ellisonleao/gruvbox.nvim" },
  { "rebelot/kanagawa.nvim" }
})

require("nvim-tree").setup({
  filters = {
    dotfiles = false,
    git_ignored = false,
  },
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("nvim-tree.api").tree.open()
  end
})

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

  local file = io.open(theme_file, "w")
  if file then
    file:write("onedark:" .. style)
    file:close()
  end
end, {
  nargs = 1,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local theme = vim.g.colors_name
    local file = io.open(theme_file, "w")
    if file then
      file:write(theme)
      file:close()
    end
  end
})

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.cmd("silent! w")
  end
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  callback = function()
    vim.cmd("silent! w")
  end
})

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "markdown",
--   callback = function()
--     vim.opt_local.wrap = true
--   end,
-- })

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = ".env",
  callback = function()
    vim.opt_local.wrap = false
    vim.opt_local.linebreak = false
  end,
})

-- vim.api.nvim_create_autocmd("BufWritePost", {
--   pattern = "*",
--   callback = function()
--     vim.cmd("botright split | terminal python app2.py")
--   end
-- })

-- toggle key (Space + e)
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

vim.keymap.set('v', '<Tab>', '>', { noremap = true })
vim.keymap.set('v', '<S-Tab>', '<', { noremap = true })

vim.keymap.set('v', '>', '>gv', { noremap = true })
vim.keymap.set('v', '<', '<gv', { noremap = true })
vim.keymap.set("n", "<leader>th", ":Telescope colorscheme<CR>")
vim.keymap.set("n", "<leader>q", ":qall!<CR>")
vim.keymap.set("n", "<C-q>", ":qall!<CR>")
vim.keymap.set("n", "qq", ":qall!<CR>")
vim.keymap.set("n", "<leader>wq", ":wqa<CR>")
vim.keymap.set("n", "<leader>r", function()
  vim.cmd("w")
  vim.cmd("terminal python app2.py")
end)
vim.keymap.set("n", "<leader>f", require("telescope.builtin").live_grep, {})
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, {})

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.lazyredraw = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.cmd("syntax on")
vim.opt.termguicolors = true
vim.opt.relativenumber = false
vim.opt.clipboard = "unnamedplus"
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.number = true

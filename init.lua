local is_windows = vim.fn.has("win32") == 1
local is_linux = vim.fn.has("unix") == 1 and not is_windows

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local theme_file = vim.fn.stdpath("config") .. "/theme.txt"
local created_dirs = {}
local term_buf = nil
local clipboard = {
  mode = nil,
  files = {},
}

-- Smart open: media files open with default OS app, others open in Neovim
local function smart_open(path)
  if not path then return end
  path = vim.fn.fnamemodify(path, ":p")
  local ext = path:match("^.+(%..+)$")
  if ext then ext = ext:lower() end

  local media_exts = {
    [".mp3"] = true, [".wav"] = true, [".flac"] = true,
    [".mp4"] = true, [".mkv"] = true, [".avi"] = true,
    [".jpg"] = true, [".jpeg"] = true, [".png"] = true,
  }

  if ext and media_exts[ext] then
    if is_windows then
      vim.fn.jobstart({ "cmd", "/c", "start", "", path }, { detach = true })
    else
      vim.fn.jobstart({
        "am", "start",
        "-a", "android.intent.action.VIEW",
        "-d", "file://" .. path,
        "-c", "android.intent.category.DEFAULT"
      }, { detach = true })
    end
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

-- Bootstrap lazy.nvim
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim",
    lazypath,
  })
end

vim.filetype.add({ extension = { sh = "sh" } })
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
  {
    "numToStr/Comment.nvim",
    config = function() require("Comment").setup() end
  },
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
    build = is_windows and "cd app && cmd /c npm install" or "cd app && npm install",
    ft = { "markdown" },
  },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "folke/tokyonight.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "EdenEast/nightfox.nvim" },
  { "navarasu/onedark.nvim" },
  { "ellisonleao/gruvbox.nvim" },
  { "rebelot/kanagawa.nvim" },
  { "andweeb/presence.nvim" },
})

-- Neo-tree: deferred to VimEnter to avoid BufModifiedSet error on Windows
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    require("neo-tree").setup({
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        use_libuv_file_watcher = not is_windows,
      },
      event_handlers = is_windows and {
        {
          event = "vim_buffer_modified_set",
          handler = function() end,
        },
      } or nil,

      window = {
        width = 30,
        mappings = {
          ["<space>"] = function(state)
            local cmds = require("neo-tree.sources.filesystem.commands")
            local node = state.tree:get_node()

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

              if choice == "New file" then
                cmds.add(state)
                vim.schedule(function() vim.cmd("startinsert") end)

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
                  print("Select a destination folder")
                  return
                end

                for _, src in ipairs(clipboard.files) do
                  local name = vim.fn.fnamemodify(src, ":t")
                  local dst = target:get_id() .. "/" .. name

                  if clipboard.mode == "copy" then
                    if is_windows then
                      -- robocopy for folders, copy for files
                      local stat = vim.loop.fs_stat(src)
                      if stat and stat.type == "directory" then
                        vim.fn.system({ "robocopy", src, dst, "/E" })
                      else
                        vim.fn.system({ "cmd", "/c", "copy", src, dst })
                      end
                    else
                      vim.fn.system({ "cp", "-R", src, dst })
                    end
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
                clipboard.mode = nil
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
                local path = node:get_id()
                vim.fn.setreg("+", path)
                print("Copied: " .. path)
              end
            end)
          end,
        },
      },
    })

    require("neo-tree.command").execute({ toggle = true })
  end,
})

require("Comment").setup()

-- Theme loading
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

-- Commands
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

-- Autocmds
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sh", "bash", "zsh" },
  callback = function()
    vim.bo.commentstring = "# %s"
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local theme = vim.g.colors_name
    local f = io.open(theme_file, "w")
    if f then
      f:write(theme)
      f:close()
    end
  end
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  callback = function()
    if vim.fn.expand("%") == "" then
      vim.cmd("bd")
    else
      vim.cmd("silent! w")
    end
  end
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = ".env",
  callback = function()
    vim.opt_local.wrap = false
    vim.opt_local.linebreak = false
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function(args)
    local config = vim.fn.fnamemodify(vim.fn.stdpath("config") .. "/init.lua", ":p")
    local f = vim.fn.fnamemodify(args.file, ":p")
    if f == config then
      vim.cmd("source " .. f)
      vim.notify("Reloaded init.lua")
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    local f = vim.fn.fnamemodify(args.file, ":p")
    local dir = vim.fn.fnamemodify(f, ":p:h")

    if vim.fn.isdirectory(dir) == 1 then return end

    if created_dirs[dir] then
      vim.fn.mkdir(dir, "p")
      return
    end

    vim.ui.select({ "Yes", "No" }, {
      prompt = "Create missing folder?\n" .. dir,
    }, function(choice)
      if choice == "Yes" then
        created_dirs[dir] = true
        vim.fn.mkdir(dir, "p")
        vim.notify("Created: " .. dir)
        vim.schedule(function() vim.cmd("silent! wall") end)
      else
        vim.notify("Skipped creating: " .. dir, vim.log.levels.WARN)
      end
    end)

    vim.cmd("abort")
  end,
})

-- Keymaps
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>")
vim.keymap.set("n", "<leader>th", ":Telescope colorscheme<CR>")
vim.keymap.set("n", "<leader>q", ":qall!<CR>")
vim.keymap.set("n", "<C-q>", ":qall!<CR>")
vim.keymap.set("n", "qq", ":qall!<CR>")
vim.keymap.set("n", "<leader>wq", ":wqa<CR>")
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')
vim.keymap.set("n", "<leader>a", "ggVG")
vim.keymap.set("v", "y", "ygv")
vim.keymap.set("v", "<Tab>", ">", { noremap = true })
vim.keymap.set("v", "<S-Tab>", "<", { noremap = true })
vim.keymap.set("v", ">", ">gv", { noremap = true })
vim.keymap.set("v", "<", "<gv", { noremap = true })

vim.keymap.set("n", "<leader>vc", function()
  require("telescope.builtin").find_files({
    cwd = vim.fn.stdpath("config"),
  })
end)

vim.keymap.set("n", "<leader>f", function()
  require("telescope.builtin").current_buffer_fuzzy_find({ previewer = false })
end)

vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").live_grep()
end)

vim.keymap.set("n", "<leader>fr", require("telescope.builtin").oldfiles, {})

vim.keymap.set("n", "<leader>fa", function()
  smart_find(vim.loop.os_homedir())
end)

vim.keymap.set("n", "<leader>fs", function()
  smart_find(is_windows and "C:/" or "/")
end)

vim.keymap.set("n", "<leader>r", function()
  vim.cmd("w")
  vim.cmd(is_windows and "terminal python app2.py" or "terminal python3 app2.py")
end)

-- Options
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.lazyredraw = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.cmd("syntax on")
vim.opt.termguicolors = true
vim.opt.relativenumber = false
vim.opt.clipboard = is_windows and "unnamed" or "unnamedplus"
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

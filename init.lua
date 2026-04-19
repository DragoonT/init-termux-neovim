-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local theme_file = vim.fn.stdpath("config") .. "/theme.txt"
local created_dirs = {}
local file = io.open(theme_file, "r")
local term_buf = nil
local function smart_open(path)
  if not path then return end

  path = vim.fn.fnamemodify(path, ":p")
  local ext = path:match("^.+(%..+)$")
  if ext then ext = ext:lower() end

  local mime = {
    -- audio
    [".mp3"] = "audio/mpeg",
    [".wav"] = "audio/wav",
    [".flac"] = "audio/flac",

    -- video
    [".mp4"] = "video/mp4",
    [".mkv"] = "video/x-matroska",
    [".avi"] = "video/x-msvideo",

    -- image
    [".jpg"] = "image/jpeg",
    [".jpeg"] = "image/jpeg",
    [".png"] = "image/png",
  }

  if ext and mime[ext] then
    local m = mime[ext]

    vim.fn.jobstart({
      "am", "start",
      "-a", "android.intent.action.VIEW",
      "-d", "file://" .. path,
      "-t", m,
      "-c", "android.intent.category.DEFAULT"
    }, { detach = true })
  else
    vim.cmd("edit " .. vim.fn.fnameescape(path))
  end
end

local function open_selected(prompt_bufnr)
  local entry = require("telescope.actions.state").get_selected_entry()
  require("telescope.actions").close(prompt_bufnr)
  smart_open(entry.path)
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

vim.filetype.add({
  extension = {
    sh = "sh",
  },
})

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
    "stevearc/dressing.nvim",
    opts = {},
  },
  -- {
  --   "nvim-tree/nvim-tree.lua",
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  --   config = function()
  --     require("nvim-tree").setup({
  --       view = {
  --         side = "left",
  --         width = 30,
  --       },
  --       renderer = {
  --         highlight_git = false,
  --         icons = {
  --           show = {
  --             git = false,
  --           },
  --         },
  --       },
  --     })
  --   end
  -- },
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

require("neo-tree").setup({
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
    },
  },

  window = {
    width = 30,

    mappings = {
      ["<space>"] = function(state)
        local cmds = require("neo-tree.sources.filesystem.commands")
        local node = state.tree:get_node()

        local function is_dir()
          return node.type == "directory"
        end

        local function get_path()
          return node:get_id()
        end

        vim.ui.select({
          "New file",
          "New folder",
          "Rename",
          "Delete",
          "Copy path",
        }, {
          prompt = "File actions:",
        }, function(choice)

          if choice == "New file" then
            cmds.add(state)
            vim.schedule(function()
              vim.cmd("startinsert")
            end)
          
          elseif choice == "New folder" then
            vim.ui.input({
              prompt = "Folder name:",
            }, function(input)
              if input and input ~= "" then
                cmds.add(state, input .. "/")
              end
            end)

          elseif choice == "Rename" then
            cmds.rename(state)

          elseif choice == "Delete" then
            vim.ui.select({ "No", "Yes" }, {
              prompt = "Delete this?",
            }, function(confirm)
              if confirm ~= "Yes" then return end

              local node = state.tree:get_node()
              if not node then return end

              local path = node:get_id()
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

require("Comment").setup()

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sh", "bash", "zsh" },
  callback = function()
    vim.bo.commentstring = "# %s"
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("neo-tree.command").execute({ toggle = true })
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
    -- vim.cmd("silent! w")
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
    local file = vim.fn.fnamemodify(args.file, ":p")

    if file == config then
      vim.cmd("source " .. file)
      vim.notify("Reloaded init.lua")
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    local file = vim.fn.fnamemodify(args.file, ":p")
    local dir = vim.fn.fnamemodify(file, ":p:h")

    if vim.fn.isdirectory(dir) == 1 then
      return
    end

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

        vim.schedule(function()
          vim.cmd("silent! wall")
        end)
      else
        vim.notify("Skipped creating: " .. dir, vim.log.levels.WARN)
      end
    end)

    vim.cmd("abort")
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    if vim.v.event.operator ~= "y" then return end

    local text = vim.fn.getreg('"')
    if text == "" then return end

    local job_id = vim.fn.jobstart({ "termux-clipboard-set" }, {
      stdin = "pipe",
    })

    if job_id > 0 then
      vim.fn.chansend(job_id, text)
      vim.fn.chanclose(job_id, "stdin")
    end
  end,
})

-- toggle key (Space + e)
vim.g.mapleader = " "

-- vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>")
vim.keymap.set("n", "<leader>vc", function()
  require("telescope.builtin").find_files({
    cwd = vim.fn.stdpath("config"),
  })
end, {})
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
vim.keymap.set("n", "<leader>f", function()
  require("telescope.builtin").current_buffer_fuzzy_find({
    previewer = false,
  })
end)
-- vim.keymap.set("n", "<leader>f", function()
--   vim.cmd("normal! /")
-- end, {})
-- vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, {})
-- vim.keymap.set("n", "<leader>fa", function()
--   require("telescope.builtin").find_files({
--     cwd = "/data/data/com.termux/files/home",
--     hidden = true,
--     no_ignore = true,
--   })
-- end, {})
-- vim.keymap.set("n", "<leader>fs", function()
--   require("telescope.builtin").find_files({
--     cwd = "/storage/emulated/0",
--     hidden = true,
--     no_ignore = true,
--   })
-- end, {})
-- current folder
vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").live_grep()
end)
-- home
vim.keymap.set("n", "<leader>fa", function()
  smart_find("/data/data/com.termux/files/home")
end, {})

-- storage
vim.keymap.set("n", "<leader>fs", function()
  smart_find("/storage/emulated/0")
end, {})
vim.keymap.set("n", "<leader>fr", require("telescope.builtin").oldfiles, {})
vim.keymap.set("v", "y", "ygv")
-- vim.keymap.set({ "n", "v" }, "y", function()
--   vim.cmd('normal! "' .. vim.v.register .. 'y')
--
--   local text = vim.fn.getreg('"')
--   if text == "" then return end
--
--   local job_id = vim.fn.jobstart({ "termux-clipboard-set" }, {
--     stdin = "pipe",
--   })
--
--   if job_id > 0 then
--     vim.fn.chansend(job_id, text)
--     vim.fn.chanclose(job_id, "stdin")
--   end
-- end, { noremap = true })
-- vim.keymap.set("n", "p", '"0p')
vim.keymap.set("n", "P", '"0P')
vim.keymap.set("n", "p", function()
  local reg0 = vim.fn.getreg("0")

  if reg0 ~= "" then
    vim.cmd('normal! "0p')
    return
  end

  vim.fn.jobstart({ "termux-clipboard-get" }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      local text = table.concat(data or {}, "\n")
      if text ~= "" then
        vim.schedule(function()
          vim.api.nvim_put(vim.split(text, "\n"), "c", true, true)
        end)
      end
    end,
  })
end, { noremap = true })
-- vim.keymap.set("n", "<leader>p", function()
--   vim.fn.jobstart({ "termux-clipboard-get" }, {
--     stdout_buffered = true,
--     on_stdout = function(_, data)
--       if not data then return end
--       local text = table.concat(data, "\n")
--       if text ~= "" then
--         vim.api.nvim_put(vim.split(text, "\n"), "c", true, true)
--       end
--     end,
--   })
-- end)
-- vim.keymap.set("n", "<leader>p", '"+p')
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')
vim.keymap.set("n", "<leader>a", "ggVG")

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.lazyredraw = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.cmd("syntax on")
vim.opt.termguicolors = true
vim.opt.relativenumber = false
vim.opt.clipboard = ""
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true


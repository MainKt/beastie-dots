vim.pack.add {
  "https://github.com/maxmx03/solarized.nvim",
  "https://github.com/kwkarlwang/bufjump.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/slugbyte/lackluster.nvim",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/NeogitOrg/neogit",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/sindrets/diffview.nvim",
  "https://github.com/mbbill/undotree",
  "https://github.com/echasnovski/mini.diff",
  "https://github.com/echasnovski/mini.icons",
  "https://github.com/echasnovski/mini.statusline",
  "https://github.com/echasnovski/mini.indentscope",
  "https://github.com/folke/lazydev.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate"
  },
}

--
-- opts
--
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.grepprg = "rg --vimgrep"
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.list = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.updatetime = 250
vim.opt.signcolumn = "yes"
vim.opt.textwidth = 80
vim.opt.colorcolumn = "80"
vim.opt.clipboard = "unnamedplus"
vim.opt.swapfile = false
vim.opt.winborder = "rounded"

vim.lsp.enable({ "clangd", "lua_ls", "zls", "rust_analyzer", "tinymist" })

local dark_theme = "lackluster-hack"
local light_theme = "solarized"

vim.schedule(function()
  vim.cmd.packadd "cfilter"

  vim.cmd("set completeopt+=noselect");
  vim.o.background = 'dark'
  vim.cmd.colorscheme(dark_theme)
end)

vim.api.nvim_create_user_command("Capture", function(opts)
  vim.cmd(
    "redir => output |" ..
    "silent " .. opts.args .. "|" ..
    "redir END |" ..
    "new |" ..
    "setlocal buftype=nofile bufhidden=hide noswapfile |" ..
    "put =output"
  )
end, { nargs = "+" })

--
-- keybindings
--
vim.keymap.set("i", "<C-k>", "<nop>")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>%", "<cmd>source %<CR>")
vim.keymap.set({"n", "v"}, "<leader>x", ":.lua<CR>")
vim.keymap.set("n", "<leader>w", "<C-W>")
vim.keymap.set("n", "co", function()
  vim.cmd(vim.fn.getqflist({ winid = 0 }).winid > 0 and "cclose" or "copen")
end)
vim.keymap.set("n", "gre", vim.diagnostic.open_float)
vim.keymap.set({ "n", "v" }, "<leader>=", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>cq", vim.diagnostic.setqflist)
vim.keymap.set("n", "<leader>cl", vim.diagnostic.setloclist)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

vim.keymap.set("n", "<leader>g", "<cmd>Neogit<CR>")

vim.keymap.set("n", "<leader><leader>", "<cmd>FzfLua files<CR>")
vim.keymap.set("n", "<leader>*", "<cmd>FzfLua grep_cword<CR>")
vim.keymap.set("v", "<leader>*", "<cmd>FzfLua grep_visual<CR>")
vim.keymap.set("n", "<leader>/", "<cmd>FzfLua live_grep<CR>")
vim.keymap.set("n", [[<leader>']], "<cmd>FzfLua resume<CR>")
vim.keymap.set("n", "<leader>,", "<cmd>FzfLua buffers<CR>")
vim.keymap.set("n", "<leader>e", "<cmd>FzfLua  diagnostics_workspace<CR>")
vim.keymap.set("n", "grs", "<cmd>FzfLua lsp_workspace_symbols<CR>")
vim.keymap.set("n", "<leader>bd", "<cmd>bp | bd#<CR>")

vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>")
vim.keymap.set("n", "-", ":Oil<Cr>")

vim.keymap.set("n", "<leader>j", "<cmd>FzfLua jumps<cr>")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-o>", "<C-o>zz")
vim.keymap.set("n", "<C-i>", "<C-i>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>t", function()
  if vim.o.background == 'light' then
    vim.o.background = 'dark'
    vim.cmd.highlight("clear")
    vim.cmd.colorscheme(dark_theme)
  else
    vim.o.background = 'light'
    vim.cmd.highlight("clear")
    vim.cmd.colorscheme(light_theme)
  end
end)

--
-- `autocmd`s
--
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.cmd.startinsert()
  end,
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  callback = function(args)
    _ = args.match:match("^l") and vim.cmd.lopen() or vim.cmd.copen()
  end,
})

--
-- plugins
--
require("lazydev").setup {
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
}

require('fzf-lua').setup {}

require("oil").setup {
  default_file_explorer = true,
  skip_confirm_for_simple_edits = true,
}

require("nvim-treesitter.configs").setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
  auto_install = true,
  highlight = {
    enable = true,
    disable = function(_, buf)
      local max_filesize = 100 * 1024
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then return true end
    end,
    additional_vim_regex_highlighting = false,
  },
}

require("mini.icons").setup {}
require("mini.statusline").setup {}
require("mini.diff").setup {}
require("mini.indentscope").setup {
  draw = { predicate = function(_) return false end },
}

local lackluster = require("lackluster")
lackluster.setup {
  tweak_background = {
    normal = lackluster.color.black,
  },
  tweak_highlight = {
    Visual = { bg = "#522d2d", fg = "none" },
  }
}

require("bufjump").setup({
  forward_key = "<C-n>",
  backward_key = "<C-p>",
  on_success = nil
})

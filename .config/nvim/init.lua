vim.pack.add {
  "https://github.com/saghen/blink.cmp",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/EdenEast/nightfox.nvim",
  "https://github.com/NeogitOrg/neogit",
  "https://github.com/sindrets/diffview.nvim",
  "https://github.com/tpope/vim-surround",
  "https://github.com/echasnovski/mini.diff",
  "https://github.com/tpope/vim-sleuth",
  "https://github.com/tpope/vim-unimpaired",
  "https://github.com/tpope/vim-repeat",
  "https://github.com/mbbill/undotree",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/rmagatti/auto-session",
  "https://github.com/echasnovski/mini.icons",
  "https://github.com/echasnovski/mini.statusline",
  "https://github.com/echasnovski/mini.indentscope",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  "https://github.com/folke/lazydev.nvim",
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate"
  },
  { src = "https://github.com/lervag/vimtex", opt = true },
}

require("lazydev").setup {
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
}

--
-- opts
--
vim.g.mapleader = " "
vim.o.grepprg = "rg --vimgrep"
vim.g.maplocalleader = " "
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

vim.schedule(function()
  vim.cmd.packadd "cfilter"
  vim.cmd.colorscheme "carbonfox"
end)

vim.api.nvim_create_user_command("Bd", "bp | bd#", {})
vim.api.nvim_create_user_command("Scratch", function(opts)
  vim.cmd(
    "new |" ..
    "setlocal buftype=nofile bufhidden=hide noswapfile |" ..
    "read !" ..
    opts.args
  )
end, { nargs = "*" })

vim.api.nvim_create_user_command("LocalJumps", function()
  vim.fn.setloclist(0, vim.tbl_map(function(j)
    return j.bufnr == vim.api.nvim_get_current_buf() and {
      bufnr = j.bufnr,
      lnum = j.lnum,
      col = j.col,
      text = vim.fn.getbufline(j.bufnr, j.lnum)[1] or ""
    } or nil
  end, vim.fn.getjumplist()[1]), 'r')
end, {})

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
vim.keymap.set("n", "<leader>x", ":.lua<CR>")
vim.keymap.set("v", "<leader>x", ":lua<CR>")
vim.keymap.set("n", "<leader>w", "<C-W>")
vim.keymap.set("n", "co", function()
  vim.cmd(vim.fn.getqflist({ winid = 0 }).winid > 0 and "cclose" or "copen")
end)
vim.keymap.set("n", "gre", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>=", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>cq", vim.diagnostic.setqflist)
vim.keymap.set("n", "<leader>cl", vim.diagnostic.setloclist)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

vim.keymap.set("n", "<leader>g", "<cmd>Neogit<CR>")

vim.keymap.set("n", "<leader><leader>", "<cmd>FzfLua files<CR>")
vim.keymap.set({ "n", "v" }, "<leader>*", "<cmd>FzfLua  grep_cword<CR>")
vim.keymap.set("n", "<leader>/", "<cmd>FzfLua live_grep<CR>")
vim.keymap.set("n", "<leader>j", "<cmd>LocalJumps<CR>")
vim.keymap.set("n", "<leader>'", "<cmd>FzfLua resume<CR>")
vim.keymap.set("n", "<leader>?", "<cmd>FzfLua oldfiles<CR>")
vim.keymap.set("n", "<leader>,", "<cmd>FzfLua buffers<CR>")
vim.keymap.set("n", "<leader>e", "<cmd>FzfLua  diagnostics_workspace<CR>")
vim.keymap.set("n", "grs", "<cmd>FzfLua lsp_workspace_symbols<CR>")

vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>")
vim.keymap.set("n", "-", ":Oil<Cr>")

vim.keymap.set("n", "<leader><Tab>", function()
  vim.cmd("SessionSave")
  vim.cmd("SessionSearch")
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
require('fzf-lua').setup {'telescope'}

local lspconfig = require "lspconfig"
local lsps = { "clangd", "lua_ls", "zls", "rust_analyzer" }
for _, lsp in pairs(lsps) do
  lspconfig[lsp].setup {}
end

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

require("auto-session").setup {
  auto_create = true,
  auto_save = true,
  suppressed_dirs = { "~/", "~/downloads", "/" },
}

require("mini.icons").setup {}
require("mini.statusline").setup {}
require("mini.diff").setup {}
require("mini.indentscope").setup {
  draw = { predicate = function(_) return false end },
}

require("blink.cmp").setup {
  keymap = { preset = 'default' },
  completion = { documentation = { auto_show = false } },
  cmdline = { enabled = false },
  sources = {
    default = { 'lazydev', 'lsp', 'snippets', 'path', 'buffer' },
    providers = {
      snippets = { score_offset = 0 },
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
    },
  },
  fuzzy = { implementation = "lua" }
}

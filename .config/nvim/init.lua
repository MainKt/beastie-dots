require "paq" {
  "savq/paq-nvim",
  "tpope/vim-sleuth",
  "stevearc/oil.nvim",
  "neovim/nvim-lspconfig",
  "EdenEast/nightfox.nvim",
  "tpope/vim-fugitive",
  "tpope/vim-surround",
  "tpope/vim-repeat",
  "mbbill/undotree",
  "lewis6991/gitsigns.nvim",
  "nvim-treesitter/nvim-treesitter-textobjects",
  "nvim-telescope/telescope.nvim",
  "nvim-telescope/telescope-fzf-native.nvim",
  "nvim-lua/plenary.nvim",
  "rmagatti/auto-session",
  "echasnovski/mini.icons",
  "echasnovski/mini.ai",
  "echasnovski/mini.statusline",
  { "lervag/vimtex", opt = true },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
}

--
-- opts
--
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
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

vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
  vim.cmd.colorscheme "carbonfox"
end)

vim.api.nvim_create_user_command("Bd", "bp | bd#", {})

--
-- keybindings
--
vim.keymap.set("i", "<C-k>", "<nop>") 
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>%", "<cmd>source %<CR>")
vim.keymap.set("n", "<leader>x", ":.lua<CR>")
vim.keymap.set("v", "<leader>x", ":lua<CR>")
vim.keymap.set("n", "<leader>w", "<C-W>")
vim.keymap.set("n", "gre", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>=", vim.lsp.buf.format)

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

vim.keymap.set("n", "<leader>g", "<cmd>Git<CR>")

vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope find_files<CR>")
vim.keymap.set({"n", "v"}, "<leader>*", "<cmd>Telescope grep_string<CR>")
vim.keymap.set("n", "<leader>/", "<cmd>Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>j", "<cmd>Telescope jumplist<CR>")
vim.keymap.set("n", "<leader>h", "<cmd>Telescope help_tags<CR>")
vim.keymap.set("n", "<leader>", "<cmd>Telescope resume<CR>")
vim.keymap.set("n", "<leader>?", "<cmd>Telescope oldfiles<CR>")
vim.keymap.set("n", "<leader>,", "<cmd>Telescope buffers<CR>")
vim.keymap.set("n", "<leader>e", "<cmd>Telescope diagnostics<CR>")
vim.keymap.set("n", "grs", "<cmd>Telescope lsp_workspace_symbols<CR>")

vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>")
vim.keymap.set("n", "-", ":Oil<Cr>")

vim.keymap.set ("n", "<leader><Tab>", function()
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

--
-- plugins
--
local lspconfig = require "lspconfig"
local lsps = { "clangd", "lua_ls" }
for _, lsp in pairs(lsps) do
  lspconfig[lsp].setup {}
end

require("gitsigns").setup {
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
}

require("oil").setup {
  default_file_explorer = true,
  skip_confirm_for_simple_edits = true,
}

require("telescope").setup {
  pickers = {
    find_files = {
      find_command = { "fd", "--type", "f", "--type", "d" },
    },
  },
  extensions = { 
    fzf = {
      fuzzy = true,                    
      override_generic_sorter = true,  
      override_file_sorter = true,    
      case_mode = "smart_case",
    },
  },
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
  suppressed_dirs = { "~/", "~/projects", "~/downloads", "/" },
}

require("mini.ai").setup {}
require("mini.icons").setup {}
require("mini.statusline").setup {}

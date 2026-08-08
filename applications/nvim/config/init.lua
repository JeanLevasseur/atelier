-- ============================================================================
-- Neovim
-- Atelier
--
-- This configuration is built incrementally.
--
-- Every line should be understood.
-- Every plugin should solve a problem observed in practice.
-- Vim's native commands are preserved whenever possible.
-- Modern capabilities are grouped under <leader>.
--
-- This configuration targets the Apple Canadian French keyboard.
-- A small compatibility layer adapts a few historical Vim keybindings
-- to the physical layout of this keyboard while preserving their meaning.
--
-- These adaptations follow two principles:
--
--   1. Preserve Vim's original meaning whenever possible.
--   2. When a shortcut is not physically accessible, preserve the
--      keyboard geography instead.
--
-- ============================================================================

-- ============================================================================
-- Keyboard compatibility (Apple Canadian French)
--
-- These mappings adapt Vim's historical keybindings to the physical layout
-- of the Apple Canadian French keyboard while preserving their meaning.
-- ============================================================================

-- Follow tag under cursor.
vim.keymap.set("n", "<C-0>", "<C-]>", {
	remap = true,
	desc = "Jump to the tag under cursor",
})

-- Alternate buffer.
vim.keymap.set("n", "<C-6>", "<C-^>", {
	remap = true,
	desc = "Edit alternate file",
})

-- ============================================================================
-- Foundation
-- Defines the core runtime and global behavior.
-- ============================================================================

vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- Appearance
-- Defines the editor's visual representation
-- ============================================================================

vim.opt.number = true

-- Always keep a few lines of context around the cursor.
vim.opt.scrolloff = 10

vim.opt.list = true
vim.opt.listchars = {
	tab = "» ",
	trail = "·",
	nbsp = "␣",
}

vim.pack.add({
	{
		src = "https://github.com/folke/tokyonight.nvim",
	},
})
vim.cmd.colorscheme("tokyonight-night")
vim.api.nvim_set_hl(0, "EndOfBuffer", {
	link = "NonText",
})

vim.opt.showmode = false
vim.pack.add({
	{
		src = "https://github.com/nvim-mini/mini.statusline",
	},
})
require("mini.statusline").setup()

vim.opt.winborder = "rounded"

vim.pack.add({
	{
		src = "https://github.com/folke/which-key.nvim",
	},
})
require("which-key").add({
	{
		"<leader>e",
		group = "Edit",
	},
})

-- TODO: to evaluate
-- vim.opt.cursorline = true

-- ============================================================================
-- Editing
-- Configures text editing behavior.
-- ============================================================================

vim.opt.breakindent = true
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.undofile = true

vim.opt.confirm = true

vim.pack.add({
	{
		src = "https://github.com/nvim-mini/mini.comment",
	},
})
require("mini.comment").setup({
	mappings = {
		comment = "<leader>ec",
		comment_line = "<leader>ec",
		comment_visual = "<leader>ec",
		textobject = "",
	},
})

vim.pack.add({
	{
		src = "https://github.com/nvim-mini/mini.surround",
	},
})
require("mini.surround").setup({
	mappings = {
		add = "<leader>ea",
		delete = "<leader>ed",
		replace = "<leader>er",
		find = "",
		find_left = "",
		highlight = "",
		update_n_lines = "",
		suffix_last = "",
		suffix_next = "",
	},
})

vim.pack.add({
	{
		src = "https://github.com/nvim-mini/mini.pairs",
	},
})
require("mini.pairs").setup()

vim.pack.add({
	{
		src = "https://github.com/stevearc/conform.nvim",
	},
})
local conform = require("conform")
conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_format" },
	},
})
vim.keymap.set("n", "<leader>ef", function()
	conform.format({ async = true })
end, {
	desc = "Édition: Formatter",
})

-- ============================================================================
-- Navigation
-- Configures window and split behavior.
-- ============================================================================

vim.opt.splitbelow = true
vim.opt.splitright = true

-- ============================================================================
-- Search
-- Configures search capabilities.
-- ============================================================================

vim.pack.add({
	{
		src = "https://github.com/nvim-lua/plenary.nvim",
	},
})
vim.pack.add({
	{
		src = "https://github.com/nvim-telescope/telescope.nvim",
	},
})
require("telescope").setup()

-- ============================================================================
--
-- Development
-- Configures language-aware development features.
-- ============================================================================

-- Syntax analysis
vim.pack.add({
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
	},
})

-- Language Server Protocol
vim.opt.signcolumn = "yes" -- Preserve space for diagnostics

vim.pack.add({
	{
		src = "https://github.com/neovim/nvim-lspconfig",
	},
})
require("lspconfig")

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
		},
	},
})
vim.lsp.enable("lua_ls")

vim.lsp.enable("pyright")

vim.lsp.enable("bashls")

vim.lsp.enable("html")
vim.lsp.enable("cssls")
vim.lsp.enable("ts_ls")

vim.lsp.enable("sqlls")

vim.lsp.enable("marksman")

-- Completion
vim.pack.add({
	{
		src = "https://github.com/Saghen/blink.cmp",
		version = "v1",
	},
})
require("blink.cmp").setup({
	keymap = {
		preset = "super-tab",
	},
	completion = {
		menu = {
			auto_show = false,
		},
	},
})

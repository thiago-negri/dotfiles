local vim = vim
local colorcolumn = "120"

vim.o.cursorline = true
vim.o.colorcolumn = colorcolumn
vim.o.signcolumn = "yes"
vim.o.backspace = "indent,eol,start"
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.inccommand = "split"
vim.o.confirm = true
vim.o.scrolloff = 10
vim.o.tabstop = 8
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.list = true
vim.o.guicursor = "a:block-nCursor"
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.showbreak = "↪ "
vim.o.breakindent = true
vim.o.undofile = true
vim.o.swapfile = true
vim.o.backup = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.laststatus = 2
vim.o.showmode = false
vim.o.mouse = "a"
vim.o.completeopt = "menuone,noselect,popup"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.g.mapleader = " "
vim.cmd.colorscheme("vim-dark")
vim.o.statusline = "%!v:lua.My_Statusline()"
vim.o.winborder = "rounded"

-- Toggle zen mode
local zen_mode = function()
	if vim.o.laststatus == 0 then
		vim.o.laststatus = 2
		vim.o.number = true
		vim.o.relativenumber = true
		vim.o.colorcolumn = colorcolumn
	else
		vim.o.laststatus = 0
		vim.o.number = false
		vim.o.relativenumber = false
		vim.o.colorcolumn = "0"
	end
end

-- Custom statusline
My_Statusline = function()
	local mode_text = ""
	local current_mode = vim.fn.mode()
	if current_mode == "n" then
		mode_text = "%#StatuslineModeNormal# N"
	elseif current_mode == "i" then
		mode_text = "%#StatuslineModeInsert# I"
	elseif current_mode == "c" then
		mode_text = "%#StatuslineModeCommand# C"
	elseif current_mode == "v" or current_mode == "V" or current_mode == "\22" then
		mode_text = "%#StatuslineModeVisual# V"
	elseif current_mode == "R" then
		mode_text = "%#StatuslineModeReplace# R"
	elseif current_mode == "r" then
		mode_text = "%#StatuslineModeOther# P"
	elseif current_mode == "!" then
		mode_text = "%#StatuslineModeOther# S"
	elseif current_mode == "t" then
		mode_text = "%#StatuslineModeOther# T"
	else
		mode_text = "%#StatuslineModeOther# O"
	end
	return mode_text .. " %#StatuslineFile# %f %m%=%Y %l,%c %p%% "
end

vim.keymap.set("n", "<F2>", zen_mode)
vim.keymap.set("n", "<F3>", "<cmd>make!<cr>")
vim.keymap.set("n", "<F5>", "<cmd>so $MYVIMRC<cr>")
vim.keymap.set({ "v", "n" }, "<leader>y", '"+y')
vim.keymap.set({ "v", "n" }, "<leader>Y", '"+Y')
vim.keymap.set({ "v", "n" }, "<leader>p", '"+p')
vim.keymap.set({ "v", "n" }, "<leader>P", '"+P')
vim.keymap.set({ "v", "n" }, "H", "^")
vim.keymap.set({ "v", "n" }, "L", "$")
vim.keymap.set("n", "yc", "yy<cmd>normal gcc<cr>p") -- Dup and comment
vim.keymap.set("n", "<leader>bc", "<cmd>let @+=@%<cr><cmd>echo 'Copied file path: ' . @%<cr>")
vim.keymap.set("n", "<leader>tw", "<cmd>set wrap!<cr>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
vim.keymap.set("n", "-", "<cmd>Oil<cr>")
vim.keymap.set("n", "<A-,>", "<cmd>cp<cr>zz") -- Previous Quickfix
vim.keymap.set("n", "<A-.>", "<cmd>cn<cr>zz") -- Next Quickfix
vim.keymap.set("n", "<A-/>", "<cmd>ccl<cr>") -- Close Quickfix
vim.keymap.set("n", "<A-?>", "<cmd>cope<cr>") -- Open Quickfix
vim.keymap.set("n", "<leader>sf", ":Pick files<cr>")
vim.keymap.set("n", "<leader>sb", ":Pick buffers<cr>")
vim.keymap.set("n", "<leader>sg", ":Pick grep_live<cr>")
vim.keymap.set("n", "<leader>sw", ":Pick grep<cr><c-r><c-w><cr>")

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	group = vim.api.nvim_create_augroup("filetype-gitcommit", { clear = true }),
	pattern = { "*.git/COMMIT_EDITMSG" },
	command = "set cc=72",
})

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlighted-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank({ timeout = 100 })
	end,
})

-- Plugins
local Plug = vim.fn["plug#"]
vim.call("plug#begin")
Plug("stevearc/oil.nvim")
Plug("kylechui/nvim-surround")
Plug("nvim-mini/mini.nvim")
Plug("stevearc/conform.nvim")
Plug("smoka7/hop.nvim")
Plug("nvim-treesitter/nvim-treesitter", {
	["do"] = function()
		vim.cmd("TSUpdate")
	end,
})
-- LSP {{{
Plug("mason-org/mason.nvim")
Plug("mason-org/mason-lspconfig.nvim")
Plug("neovim/nvim-lspconfig")
Plug("WhoIsSethDaniel/mason-tool-installer.nvim")
Plug("j-hui/fidget.nvim")
Plug("saghen/blink.cmp", { ["tag"] = "v1.*" })
-- }}}
vim.call("plug#end")

-- Plugin options
local setup_plugins = function()
	require("oil").setup({
		default_file_explorer = true,
		view_options = { show_hidden = true },
		columns = { "permissions", "mtime", "size" },
		constrain_cursor = "name",
	})
	require("nvim-surround").setup()
	require("mini.ai").setup({ n_lines = 500 })
	require("mini.surround").setup()
	require("mini.pick").setup()
	require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
	vim.keymap.set("n", "<c-j>", "<cmd>HopChar1<cr>")
	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"bash",
			"c",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
			"typescript",
		},
		auto_install = true,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = { "ruby" },
		},
		indent = { enable = true, disable = { "ruby" } },
	})

	-- LSP {{{
	require("mason").setup()
	require("fidget").setup()

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
		callback = function(event)
			local map = function(keys, func, desc, mode)
				mode = mode or "n"
				vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
			end

			vim.keymap.set("n", "grn", vim.lsp.buf.rename)
			vim.keymap.set({ "n", "x" }, "gra", vim.lsp.buf.code_action)
			vim.keymap.set("n", "grr", vim.lsp.buf.references)
			vim.keymap.set("n", "grD", vim.lsp.buf.declaration)
			vim.keymap.set("n", "grd", vim.lsp.buf.definition)

			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
				map("<leader>th", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
				end, "[T]oggle Inlay [H]ints")
			end
		end,
	})

	vim.diagnostic.config({
		severity_sort = true,
		float = { border = "rounded", source = "if_many" },
		underline = { severity = vim.diagnostic.severity.ERROR },
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "󰅚 ",
				[vim.diagnostic.severity.WARN] = "󰀪 ",
				[vim.diagnostic.severity.INFO] = "󰋽 ",
				[vim.diagnostic.severity.HINT] = "󰌶 ",
			},
		},
		virtual_text = {
			source = "if_many",
			spacing = 2,
			format = function(diagnostic)
				local diagnostic_message = {
					[vim.diagnostic.severity.ERROR] = diagnostic.message,
					[vim.diagnostic.severity.WARN] = diagnostic.message,
					[vim.diagnostic.severity.INFO] = diagnostic.message,
					[vim.diagnostic.severity.HINT] = diagnostic.message,
				}
				return diagnostic_message[diagnostic.severity]
			end,
		},
	})

	local capabilities = require("blink.cmp").get_lsp_capabilities()

	local servers = {
		clangd = {},
		ts_ls = {},
		lua_ls = {
			settings = {
				Lua = {
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		},
	}

	require("mason-tool-installer").setup({ ensure_installed = { "clangd", "ts_ls", "lua_ls", "stylua" } })

	require("mason-lspconfig").setup({
		ensure_installed = {},
		automatic_installation = false,
		handlers = {
			function(server_name)
				local server = servers[server_name] or {}
				server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
				require("lspconfig")[server_name].setup(server)
			end,
		},
	})
	-- LSP }}}

	local conform = require("conform")
	conform.setup({
		notify_on_error = false,
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
		},
	})
	vim.keymap.set("n", "<leader>f", function()
		conform.format({ async = true, lsp_format = "fallback" })
	end)

	local blink = require("blink.cmp")
	blink.setup({
		completion = {
			menu = { auto_show = false },
		},
		keymap = { preset = "default", ["<c-j>"] = {
			function(cmp)
				cmp.show()
			end,
		} },
		appearance = { nerd_font_variant = "mono" },
		sources = { default = { "lsp", "path" } },
		fuzzy = { implementation = "lua" },
		signature = { enabled = true },
	})
end
vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("plugins-setup", { clear = true }),
	callback = setup_plugins,
})

-- vim: ts=2

return {
	{
		"stevearc/conform.nvim",
		-- event = 'BufWritePre', -- uncomment for format on save
		opts = require("configs.conform"),
	},
	{
		"hedyhli/outline.nvim",
		config = function()
			require("outline").setup({
				outline_window = {
					position = "left",
				},
			})
		end,
		keys = {
			{ "<leader>ar", "<cmd>Outline<cr>", desc = "Outline Toggle" },
		},
	},
	-- These are some examples, uncomment them if you want to see them work!
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("configs.lspconfig")
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
	},

	-- test new blink
	-- { import = "nvchad.blink.lazyspec" },

	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"vimdoc",
				-- "html",
				-- "css",
				-- "lua",
				-- "vim",
			},
		},
	},

	-- Clipboard manager
	{
		"AckslD/nvim-neoclip.lua",
		event = "VeryLazy",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
		},
		opts = {
			history = 200,
			enable_persistent_history = false,
			preview = true,
		},
		keys = {
			{ "<leader>sy", "<cmd>Telescope neoclip<cr>", desc = "Neoclip" },
		},
	},

	-- Telescope symbols sources (emoji/kaomoji/gitmoji/etc.)
	{
		"nvim-telescope/telescope-symbols.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-telescope/telescope.nvim" },
	},

	-- URL viewer
	{
		"axieax/urlview.nvim",
		cmd = "UrlView",
		opts = {
			default_action = "system",
			default_picker = "telescope",
		},
		keys = {
			{ "<leader>su", "<cmd>UrlView<cr>", desc = "URL View" },
		},
	},

	-- Multi-cursor
	{
		"mg979/vim-visual-multi",
		branch = "master",
		event = "VeryLazy",
	},

	-- Surround motions (add/change/delete brackets, quotes, etc.)
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		init = function()
			vim.g.nvim_surround_no_visual_mappings = true
		end,
		opts = {},
		keys = {
			{ "s", mode = "x", "<Plug>(nvim-surround-visual)", desc = "Surround (Visual)" },
		},
	},

	-- Fold text UI
	{
		"OXY2DEV/foldtext.nvim",
		event = "VeryLazy",
		opts = {},
	},

	-- Refactoring tools
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {},
		keys = {
			{ "<leader>rr", "<cmd>Refactor<cr>", desc = "Refactor (Pick)" },
			{ "<leader>re", "<cmd>Refactor extract<cr>", desc = "Refactor Extract" },
			{ "<leader>rf", "<cmd>Refactor extract_to_file<cr>", desc = "Refactor Extract To File" },
			{ "<leader>rv", "<cmd>Refactor extract_var<cr>", desc = "Refactor Extract Variable" },
			{ "<leader>ri", "<cmd>Refactor inline_var<cr>", desc = "Refactor Inline Variable" },
			{ "<leader>rI", "<cmd>Refactor inline_func<cr>", desc = "Refactor Inline Function" },
			{ "<leader>rb", "<cmd>Refactor extract_block<cr>", desc = "Refactor Extract Block" },
			{ "<leader>rB", "<cmd>Refactor extract_block_to_file<cr>", desc = "Refactor Extract Block To File" },
		},
	},

	-- Docstring generator
	{
		"danymat/neogen",
		event = "VeryLazy",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {},
		keys = {
			{ "<leader>ng", "<cmd>Neogen<cr>", desc = "Generate Docstring" },
		},
	},

	-- Git: diff view + history
	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
			{ "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
			-- { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "File History" },
		},
	},

	-- Git: full porcelain
	-- {
	-- 	"tpope/vim-fugitive",
	-- 	cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Gblame", "Gvdiffsplit" },
	-- 	keys = {
	-- 		{ "<leader>gg", "<cmd>Git<cr>", desc = "Git Status" },
	-- 		{ "<leader>gb", "<cmd>Gblame<cr>", desc = "Git Blame" },
	-- 	},
	-- },

	-- Git: Magit-style UI
	{
		"NeogitOrg/neogit",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
		},
		opts = {},
		keys = {
			{ "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
		},
	},

	-- Git: line commit info popup
	{
		"rhysd/git-messenger.vim",
		cmd = { "GitMessenger" },
		keys = {
			{ "<leader>gm", "<cmd>GitMessenger<cr>", desc = "Git Messenger" },
		},
	},

	-- Git: copy repo/line links
	{
		"linrongbin16/gitlinker.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
		keys = {
			{ "<leader>gL", "<cmd>GitLink<cr>", desc = "Copy Git Link" },
		},
	},

	{
		"phaazon/hop.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{ "s", "<cmd>HopWord<cr>", desc = "Hop Word" },
			{ "S", "<cmd>HopLine<cr>", desc = "Hop Line" },
		},
	},

	-- Search & jump
	-- {
	-- 	"woosaaahh/sj.nvim",
	-- 	config = function()
	-- 		local sj = require("sj")
	-- 		sj.setup({
	-- 			separator = ";",
	-- 		})
	-- 	end,
	-- 	keys = {
	-- 		{
	-- 			"s",
	-- 			function()
	-- 				require("sj").run()
	-- 			end,
	-- 			desc = "Search Jump",
	-- 		},
	-- 		{
	-- 			"<A-,>",
	-- 			function()
	-- 				require("sj").prev_match()
	-- 			end,
	-- 			desc = "SJ Prev Match",
	-- 		},
	-- 		{
	-- 			"<A-;>",
	-- 			function()
	-- 				require("sj").next_match()
	-- 			end,
	-- 			desc = "SJ Next Match",
	-- 		},
	-- 		{
	-- 			"<localleader>s",
	-- 			function()
	-- 				require("sj").redo()
	-- 			end,
	-- 			desc = "SJ Redo",
	-- 		},
	-- 	},
	-- },

	{
		"MagicDuck/grug-far.nvim",
		cmd = { "GrugFar" },
		keys = {
			{
				"<leader>sr",
				function()
					require("grug-far").open()
				end,
				desc = "Search & Replace (GrugFar)",
			},
		},
		config = function()
			require("grug-far").setup({
				border = "single",
				engine = "ripgrep",
				helpWindow = { border = "single" },
				historyWindow = { border = "single" },
				previewWindow = { border = "single" },
				-- Using <localleader>s (usually '\') or a specific prefix like 'r'
				-- inside the buffer prevents conflicts with your global <leader>ss
				keymaps = {
					replace = { n = "<leader>sy" },
					qflist = { n = "<leader>sq" },
					syncLocations = { n = "<leader>sa" },
					syncLine = { n = "<leader>sl" },
					close = { n = "<leader>sc" },
					historyOpen = { n = "<leader>sh" },
					historyAdd = { n = "<leader>sa" },
					refresh = { n = "<leader>sf" },
					gotoLocation = { n = "<leader>sg" },
					pickHistory = { n = "<leader>sp" },
					abort = { n = "<leader>sk" },
					toggleMode = { n = "<leader>st" },
				},
			})
		end,
	},
	{
		"echasnovski/mini.map",
		version = false,
		keys = {
			{
				"<leader>mo",
				function()
					require("mini.map").open()
				end,
				desc = "Minimap Open",
			},
			{
				"<leader>mc",
				function()
					require("mini.map").close()
				end,
				desc = "Minimap Close",
			},
			{
				"<leader>mm",
				function()
					require("mini.map").toggle()
				end,
				desc = "Minimap Toggle",
			},
			{
				"<leader>mf",
				function()
					require("mini.map").toggle_focus()
				end,
				desc = "Minimap Focus",
			},
		},
		config = function()
			local map = require("mini.map")

			map.setup({
				integrations = {
					map.gen_integration.builtin_search(),
					map.gen_integration.diagnostic(),
					map.gen_integration.diff(),
					map.gen_integration.gitsigns(),
				},
				symbols = {
					encode = map.gen_encode_symbols.dot("4x2"),
				},
				window = {
					side = "right",
					width = 20,
					winblend = 0,
				},
			})
		end,
	},
	{
		"SmiteshP/nvim-navic",
		event = "LspAttach",
		opts = {
			highlight = true,
			separator = "  ",
			lsp = {
				auto_attach = true,
			},
			icons = {
				File = "󰈙 ",
				Module = " ",
				Namespace = "󰌗 ",
				Package = " ",
				Class = "󰌗 ",
				Method = "󰆧 ",
				Property = " ",
				Field = " ",
				Constructor = " ",
				Enum = "󰕘 ",
				Interface = "󰕘 ",
				Function = "󰊕 ",
				Variable = "󰀫 ",
				Constant = "󰏿 ",
				String = "󰀬 ",
				Number = "󰎠 ",
				Boolean = "󰨙 ",
				Array = "󰅪 ",
				Object = "󰅩 ",
				Key = "󰌋 ",
				Null = "󰟢 ",
				EnumMember = "󰕘 ",
				Struct = "󰌗 ",
				Event = "󰉁 ",
				Operator = "󰆕 ",
				TypeParameter = "󰊄 ",
			},
			depth_limit = 0,
		},
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		config = function()
			require("tiny-inline-diagnostic").setup({
				options = {
					show_code = false,
					multilines = { enabled = true, always_show = true },
					show_source = { enabled = false },
					show_all_diags_on_cursorline = true,
					show_diags_only_under_cursor = false,
				},
			})
			vim.diagnostic.config({
				virtual_text = false,
				virtual_lines = false,
			}) -- Disable Neovim's default virtual diagnostics
		end, --
	},
	{
		"neovim/nvim-lspconfig",
		opts = { diagnostics = { virtual_text = false, virtual_lines = false } },
	},
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		opts = {},
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>xs",
				"<cmd>Trouble symbols toggle focus=true win.position=left<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>xl",
				"<cmd>Trouble lsp toggle focus=false win.position=left<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		opts = function(_, opts)
			local ok, trouble = pcall(require, "trouble.sources.telescope")
			if not ok then
				return
			end
			opts.defaults = opts.defaults or {}
			opts.defaults.mappings = opts.defaults.mappings or {}
			opts.defaults.mappings.i = opts.defaults.mappings.i or {}
			opts.defaults.mappings.n = opts.defaults.mappings.n or {}
			opts.defaults.mappings.i["<C-t>"] = trouble.open
			opts.defaults.mappings.n["<C-t>"] = trouble.open
			opts.defaults.mappings.i["<leader>xt"] = trouble.open
			opts.defaults.mappings.n["<leader>xt"] = trouble.open
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VimEnter",
		opts_extend = { "spec" },
		opts = {
			preset = "helix",
			defaults = {},
			spec = {
				{
					mode = { "n", "x" },
					{ "<leader><tab>", group = "tabs" },
					{ "<leader>c", group = "code" },
					{ "<leader>d", group = "debug" },
					{ "<leader>dp", group = "profiler" },
					{ "<leader>f", group = "file/find" },
					{ "<leader>g", group = "git" },
					{ "<leader>gh", group = "hunks" },
					{ "<leader>q", group = "quit/session" },
					{ "<leader>s", group = "search" },
					{ "<leader>u", group = "ui" },
					{ "<leader>x", group = "diagnostics/quickfix" },
					{ "<leader>a", group = "ai" },
					{ "<leader>m", group = "marks" },
					{ "<leader>p", group = "picker" },
					{ "<leader>z", group = "zen" },
					{ "[", group = "prev" },
					{ "]", group = "next" },
					{ "g", group = "goto" },
					{ "gz", group = "surround" },
					{ "z", group = "fold" },
					{
						"<leader>b",
						group = "buffer",
						expand = function()
							return require("which-key.extras").expand.buf()
						end,
					},
					{
						"<leader>w",
						group = "windows",
						proxy = "<c-w>",
						expand = function()
							return require("which-key.extras").expand.win()
						end,
					},
					-- better descriptions
					{ "gx", desc = "Open with system app" },
				},
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Keymaps (which-key)",
			},
			{
				"<c-w><space>",
				function()
					require("which-key").show({ keys = "<c-w>", loop = true })
				end,
				desc = "Window Hydra Mode (which-key)",
			},
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			if not vim.tbl_isempty(opts.defaults) then
				LazyVim.warn("which-key: opts.defaults is deprecated. Please use opts.spec instead.")
				wk.register(opts.defaults)
			end
		end,
	},
}

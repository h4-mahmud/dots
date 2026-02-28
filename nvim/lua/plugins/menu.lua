return {

	{ "nvzone/volt", lazy = false },
	{
		"nvzone/minty",
		cmd = { "Shades", "Huefy" },
		keys = {
			{ "<leader>cc", "<cmd>Shades<cr>", desc = "Fancy Color Grid (Shades)" },
			{ "<leader>cp", "<cmd>Huefy<cr>", desc = "Fancy Hue Slider (Huefy)" },
		},
	},

	{
		"nvzone/menu",
		lazy = true,
	},
	{
		"nvzone/typr",
		dependencies = "nvzone/volt",
		opts = {},
		cmd = { "Typr", "TyprStats" },
	},
	{
		"nvzone/showkeys",
		cmd = "ShowkeysToggle",
		opts = {
			timeout = 1,
			maxkeys = 5,
			-- more opts
		},
	},
	{
		"nvzone/floaterm",
		dependencies = "nvzone/volt",
		cmd = "FloatermToggle",
		opts = {
			border = true,

			mappings = { sidebar = nil, term = nil },

			terminals = {
				{ name = "Terminal" },
				{ name = "Terminal", cmd = "neofetch" },
			},

			mappings = {
				term = function(buf)
					vim.keymap.set({ "n", "t" }, "<C-p>", function()
						require("floaterm.api").cycle_term_bufs("prev")
					end, { buffer = buf })
				end,
			},
		},
	},
}

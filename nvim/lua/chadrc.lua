-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "chadracula-evondev",
	transparency = false,
	theme_toggle = { "rosepine", "chadracula-evondev" },
	hl_override = {

		TelescopeSelection = { bg = "purple", fg = "black" },
		NvimTreeCursorLine = { bg = "one_bg3" },

		Comment = { italic = true },
		Keyword = { italic = true },
		Conditional = { italic = true },
		Repeat = { italic = true },
		Exception = { italic = true },
		["@comment"] = { italic = true },
		["@keyword"] = { italic = true },
		["@keyword.conditional"] = { italic = true },
		["@keyword.repeat"] = { italic = true },
		["@keyword.exception"] = { italic = true },
		["@text.strong"] = { bold = true },
		["@markup.strong"] = { bold = true },
		["@text.emphasis"] = { italic = true },
		["@markup.italic"] = { italic = true },
	},

	integrations = {
		"dap",
		"hop",
		"navic",
		"leap",
		"grug_far",
		"lsp",
		"notify",
		"whichkey",
		"alpha",
		"avante",
		"codeactionmenu",
		"git",
		"git-conflict",
		"lspsaga",
		"defaults",
		"diffview",
		"tiny-inline-diagnostic",
		"mini-tabline",
		"neogit",
		"rainbowdelimiters",
		"render-markdown",
	},
}

M.nvdash = {
	load_on_startup = false,
	header = {
		"███▄▄▄▄      ▄████████  ▄██████▄   ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄  ",
		"███▀▀▀██▄   ███    ███ ███    ███ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄",
		"███   ███   ███    █▀  ███    ███ ███    ███ ███▌ ███   ███   ███",
		"███   ███  ▄███▄▄▄     ███    ███ ███    ███ ███▌ ███   ███   ███",
		"███   ███ ▀▀███▀▀▀     ███    ███ ███    ███ ███▌ ███   ███   ███",
		"███   ███   ███    █▄  ███    ███ ███    ███ ███  ███   ███   ███",
		"███   ███   ███    ███ ███    ███ ███    ███ ███  ███   ███   ███",
		" ▀█   █▀    ██████████  ▀██████▀   ▀██████▀  █▀    ▀█   ███   █▀ ",
	},
	buttons = {},
}

-- M.ui = {
-- }
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		vim.opt.fillchars = {
			eob = " ",
			fold = " ",
		}
	end,
})

vim.g.TbTabsToggled = 0
local function setup_tabufline_rounded_active()
	local ok_utils, tb_utils = pcall(require, "nvchad.tabufline.utils")
	if not ok_utils then
		return
	end

	if not vim.g._tb_round_active_patched then
		local original = tb_utils.style_buf
		tb_utils.style_buf = function(nr, i, w)
			local buf = original(nr, i, w)
			if vim.api.nvim_get_current_buf() ~= nr then
				return buf
			end
			local txt = tb_utils.txt
			return txt(" ▌", "BufOnIndicator") .. buf
		end
		vim.g._tb_round_active_patched = true
	end
	package.loaded["nvchad.tabufline.modules"] = nil
	vim.cmd("redrawtabline")
end

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
	callback = function()
		local ok_base46, base46 = pcall(require, "base46")
		if ok_base46 then
			local colors = base46.get_theme_tb("base_30")
			local fg = colors.blue or colors.nord_blue or colors.red
			if fg then
				vim.api.nvim_set_hl(0, "TbBufOnIndicator", { fg = fg, bold = true })
			end
		end
		setup_tabufline_rounded_active()
	end,
})

M.ui = {

	tabufline = {
		enabled = true,
		lazyload = false,
		bufwidth = 24,
		order = { "treeOffset", "buffers", "tabs", "btns" },
		modules = {
			tabs = function()
				local fn = vim.fn
				local g = vim.g
				local btn = require("nvchad.tabufline.utils").btn

				local result, tabs = "", fn.tabpagenr("$")
				for nr = 1, tabs, 1 do
					local tab_hl = "TabO" .. (nr == fn.tabpagenr() and "n" or "ff")
					result = result .. btn(" " .. nr .. " ", tab_hl, "GotoTab", nr)
				end

				local new_tabtn = btn(" 󰐕 ", "TabNewBtn", "NewTab")
				local tabstoggleBtn = btn(" TABS ", "TabTitle", "ToggleTabs")
				return new_tabtn .. tabstoggleBtn .. result
			end,
		},
	},
	statusline = {
		theme = "default",
		separator_style = "round",
		order = { "mode", "file", "git", "navic", "%=", "macro", "showcmd", "lsp_msg", "diagnostics", "lsp", "cursor" },
		modules = {
			mode = function()
				local utils = require("nvchad.stl.utils")
				if not utils.is_activewin() then
					return ""
				end

				local sep_style = require("nvconfig").ui.statusline.separator_style
				local sep_icons = utils.separators
				local separators = (type(sep_style) == "table" and sep_style) or sep_icons[sep_style]
				local sep_r = separators.right

				local modes = utils.modes
				local m = vim.api.nvim_get_mode().mode
				local current_mode = "%#St_" .. modes[m][2] .. "Mode#    " .. modes[m][1] .. "  "
				local mode_sep1 = "%#St_" .. modes[m][2] .. "ModeSep#" .. sep_r
				return current_mode .. mode_sep1 .. "%#ST_EmptySpace#" .. sep_r
			end,
			file = function()
				local utils = require("nvchad.stl.utils")
				local sep_style = require("nvconfig").ui.statusline.separator_style
				local sep_icons = utils.separators
				local separators = (type(sep_style) == "table" and sep_style) or sep_icons[sep_style]
				local sep_r = separators.right
				local x = utils.file()
				local name = " " .. x[2] .. (sep_style == "default" and " " or "  ")
				return " %#St_file# " .. x[1] .. name .. "%#St_file_sep#" .. sep_r
			end,
			git = function()
				local utils = require("nvchad.stl.utils")
				local git = utils.git()
				return git ~= "" and ("%#St_gitIcons#" .. git .. " ") or ""
			end,
			lsp_msg = function()
				local utils = require("nvchad.stl.utils")
				return "%#St_LspMsg#" .. utils.lsp_msg()
			end,
			diagnostics = function()
				local utils = require("nvchad.stl.utils")
				return utils.diagnostics()
			end,
			macro = function()
				local recording_register = vim.fn.reg_recording()
				if recording_register == "" then
					return ""
				end
				return "%#St_lspError#   Recording @" .. recording_register .. " "
			end,
			showcmd = function()
				return "%#St_LspMsg# %S "
			end,
			navic = function()
				local ok, n = pcall(require, "nvim-navic")
				if ok and n.is_available() then
					local loc = n.get_location()
					if loc ~= "" then
						return "%#St_Lsp#    " .. loc .. "  "
					end
				end
				return ""
			end,
			lsp = function()
				if not rawget(vim, "lsp") then
					return ""
				end
				for _, client in ipairs(vim.lsp.get_clients()) do
					if client.attached_buffers[vim.api.nvim_get_current_buf()] then
						return "%#St_Lsp#  " .. client.name .. " "
					end
				end
				return ""
			end,
			cursor = function()
				local sep_style = require("nvconfig").ui.statusline.separator_style
				local utils = require("nvchad.stl.utils")
				local sep_icons = utils.separators
				local separators = (type(sep_style) == "table" and sep_style) or sep_icons[sep_style]
				local sep_l = separators["left"]
				return "%#St_pos_sep#" .. sep_l .. "%#St_pos_icon#    %#St_pos_text#  %p%%   "
			end,
		},
	},
	-- ... keep the rest of your UI config (cmp, telescope, etc.)
	cmp = {
		icons_left = true, -- only for non-atom styles!
		style = "default", -- default/flat_light/flat_dark/atom/atom_colored
		abbr_maxwidth = 60,
		-- for tailwind, css lsp etc
		format_colors = { lsp = true, icon = "󱓻" },
	},
	telescope = { style = "bordered" },
}

return M

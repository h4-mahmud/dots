require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt ='both' -- to enable cursorline!
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.backup = false
vim.opt.title = true
vim.opt.hlsearch = true
vim.opt.expandtab = true
vim.opt.scrolloff = 5
vim.opt.breakindent = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.wrap = true
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.showcmd = true
vim.opt.showcmdloc = "statusline"
vim.opt.statuscolumn = "%s %=%{&relativenumber && v:relnum ? v:relnum : v:lnum} %#Normal#%{repeat(' ', 1)}"
vim.opt.cursorline = true
vim.opt.list = false
vim.opt.listchars = { space = "·", tab = "» ", trail = "·", extends = "›", precedes = "‹" }
vim.diagnostic.config({ virtual_text = false, virtual_lines = false })
-- vim.opt.fillchars:append({ vert = "▏" })
-- vim.api.nvim_set_hl(0, "Visual", { bg = "#2b3448" })

local function is_visual_mode(mode)
	return mode == "v" or mode == "V" or mode == "\022"
end

vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "*",
	callback = function()
		local new_mode = vim.v.event.new_mode
		local old_mode = vim.v.event.old_mode
		if is_visual_mode(new_mode) and not is_visual_mode(old_mode) then
			vim.b._list_prev = vim.wo.list
			vim.wo.list = true
			return
		end
		if is_visual_mode(old_mode) and not is_visual_mode(new_mode) then
			if vim.b._list_prev ~= nil then
				vim.wo.list = vim.b._list_prev
				vim.b._list_prev = nil
			else
				vim.wo.list = false
			end
		end
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function()
		vim.diagnostic.config({ virtual_text = false, virtual_lines = false })
	end,
})



local function apply_navic_hl()
	vim.api.nvim_set_hl(0, "NavicText", { link = "Normal" })
	vim.api.nvim_set_hl(0, "NavicSeparator", { link = "Comment" })
	vim.api.nvim_set_hl(0, "NavicIconsFile", { link = "Directory" })
	vim.api.nvim_set_hl(0, "NavicIconsModule", { link = "Special" })
	vim.api.nvim_set_hl(0, "NavicIconsNamespace", { link = "Special" })
	vim.api.nvim_set_hl(0, "NavicIconsPackage", { link = "Special" })
	vim.api.nvim_set_hl(0, "NavicIconsClass", { link = "Type" })
	vim.api.nvim_set_hl(0, "NavicIconsMethod", { link = "Function" })
	vim.api.nvim_set_hl(0, "NavicIconsProperty", { link = "Identifier" })
	vim.api.nvim_set_hl(0, "NavicIconsField", { link = "Identifier" })
	vim.api.nvim_set_hl(0, "NavicIconsConstructor", { link = "Type" })
	vim.api.nvim_set_hl(0, "NavicIconsEnum", { link = "Type" })
	vim.api.nvim_set_hl(0, "NavicIconsInterface", { link = "Type" })
	vim.api.nvim_set_hl(0, "NavicIconsFunction", { link = "Function" })
	vim.api.nvim_set_hl(0, "NavicIconsVariable", { link = "Identifier" })
	vim.api.nvim_set_hl(0, "NavicIconsConstant", { link = "Constant" })
	vim.api.nvim_set_hl(0, "NavicIconsString", { link = "String" })
	vim.api.nvim_set_hl(0, "NavicIconsNumber", { link = "Number" })
	vim.api.nvim_set_hl(0, "NavicIconsBoolean", { link = "Boolean" })
	vim.api.nvim_set_hl(0, "NavicIconsArray", { link = "Type" })
	vim.api.nvim_set_hl(0, "NavicIconsObject", { link = "Type" })
	vim.api.nvim_set_hl(0, "NavicIconsKey", { link = "Identifier" })
	vim.api.nvim_set_hl(0, "NavicIconsNull", { link = "Comment" })
	vim.api.nvim_set_hl(0, "NavicIconsEnumMember", { link = "Identifier" })
	vim.api.nvim_set_hl(0, "NavicIconsStruct", { link = "Type" })
	vim.api.nvim_set_hl(0, "NavicIconsEvent", { link = "Special" })
	vim.api.nvim_set_hl(0, "NavicIconsOperator", { link = "Operator" })
	vim.api.nvim_set_hl(0, "NavicIconsTypeParameter", { link = "Type" })
end

apply_navic_hl()





















-- NvimTree live filter input uses default styling

-- NvChad nvdash gradient header
local nvdash_header = {
	"███▄▄▄▄      ▄████████  ▄██████▄   ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄  ",
	"███▀▀▀██▄   ███    ███ ███    ███ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄",
	"███   ███   ███    █▀  ███    ███ ███    ███ ███▌ ███   ███   ███",
	"███   ███  ▄███▄▄▄     ███    ███ ███    ███ ███▌ ███   ███   ███",
	"███   ███ ▀▀███▀▀▀     ███    ███ ███    ███ ███▌ ███   ███   ███",
	"███   ███   ███    █▄  ███    ███ ███    ███ ███  ███   ███   ███",
	"███   ███   ███    ███ ███    ███ ███    ███ ███  ███   ███   ███",
	" ▀█   █▀    ██████████  ▀██████▀   ▀██████▀  █▀    ▀█   ███   █▀ ",
}

local nvdash_gradient = {
	"#7aa2f7",
	"#86b0ff",
	"#92beff",
	"#9fccff",
	"#acdaff",
	"#b9e7ff",
	"#c6f0ff",
	"#d3f7ff",
}

local function apply_nvdash_gradient(retries)
	retries = retries or 0
	local buf = vim.g.nvdash_buf
	local win = vim.g.nvdash_win
	if not (buf and win and vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_win_is_valid(win)) then
		if retries < 10 then
			vim.defer_fn(function()
				apply_nvdash_gradient(retries + 1)
			end, 20)
		end
		return
	end

	local ns = vim.api.nvim_create_namespace("nvdash")
	vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

	for i, color in ipairs(nvdash_gradient) do
		local hl = "NvDashAscii" .. i
		vim.api.nvim_set_hl(0, hl, { fg = color, bold = true })
	end

	local winh = vim.api.nvim_win_get_height(win)
	local winw = vim.api.nvim_win_get_width(win)
	local dashboard_h = #nvdash_header + 3
	local row_i = math.floor((winh / 2) - (dashboard_h / 2))

	for i, line in ipairs(nvdash_header) do
		local col = math.floor((winw / 2) - math.floor(vim.api.nvim_strwidth(line) / 2)) - 6
		local hl = "NvDashAscii" .. math.min(i, #nvdash_gradient)
		vim.api.nvim_buf_set_extmark(buf, ns, row_i + i, 0, {
			virt_text_win_col = col,
			virt_text = { { line, hl } },
		})
	end
end

local function apply_cursorline_nr_hl()
	local ok_base46, base46 = pcall(require, "base46")
	if ok_base46 then
		local colors = base46.get_theme_tb("base_30")
		local fg = colors.orange or colors.yellow or colors.nord_blue or colors.green or colors.red
		if fg then
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = fg, bold = true })
			return
		end
	end

	local ok_warn, warn = pcall(vim.api.nvim_get_hl, 0, { name = "DiagnosticWarn" })
	local ok_cur, cur = pcall(vim.api.nvim_get_hl, 0, { name = "CursorLineNr" })
	local fg = (ok_warn and (warn.fg or warn.foreground)) or (ok_cur and (cur.fg or cur.foreground))
	if fg then
		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = fg, bold = true })
	end
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "nvdash",
	callback = function()
		vim.defer_fn(function()
			apply_nvdash_gradient(0)
		end, 10)
		vim.g.TbTabsToggled = 1
		vim.cmd("redrawtabline")
		-- Remove nvdash navigation mappings so cursor can move freely.
		pcall(vim.keymap.del, "n", "j", { buffer = true })
		pcall(vim.keymap.del, "n", "k", { buffer = true })
		pcall(vim.keymap.del, "n", "<down>", { buffer = true })
		pcall(vim.keymap.del, "n", "<up>", { buffer = true })
		pcall(vim.keymap.del, "n", "<cr>", { buffer = true })
end,
})

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
	callback = function()
		apply_cursorline_nr_hl()
	end,
})


vim.api.nvim_create_autocmd({ "VimResized", "WinResized", "WinEnter", "BufWinEnter" }, {
	callback = function()
		if vim.bo.filetype == "nvdash" then
			vim.defer_fn(function()
				apply_nvdash_gradient(0)
			end, 10)
		end
	end,
})

-- Cmdline auto-completion using built-in wildmenu
vim.opt.wildmenu = true
vim.opt.wildmode = "noselect:lastused,full"
vim.opt.wildoptions = "pum"
vim.opt.pumheight = 15

vim.api.nvim_create_autocmd("CmdlineChanged", {
	pattern = { ":" },
	callback = function()
		if vim.fn.getcmdtype() ~= ":" then
			return
		end
		local cmd = vim.fn.getcmdline()
		if cmd:match("^%%?s/") then
			return
		end
		pcall(vim.fn.wildtrigger)
	end,
})

-- Keep history navigation when wildmenu is active

-- Disable animated indent line in non-code buffers
vim.api.nvim_create_autocmd({ "FileType", "TermOpen" }, {
	pattern = {
		"help",
		"qf",
		"terminal",
		"NvimTree",
		"neo-tree",
		"snacks_dashboard",
		"dashboard",
		"nvdash",
		"lazy",
		"mason",
		"TelescopePrompt",
		"Trouble",
		"NvMenu",
		"VoltWindow",
		"oil",
		"toggleterm",
		"floaterm",
		"lspinfo",
		"checkhealth",
	},
	callback = function()
		vim.b.miniindentscope_disable = true
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		vim.b.miniindentscope_disable = true
	end,
})







vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter", "WinEnter" }, {
	pattern = "NvimTree",
	callback = function()
		vim.wo.number = false
		vim.wo.relativenumber = false
		vim.wo.cursorline = true
		vim.wo.statuscolumn = ""
		-- vim.wo.winhighlight = "WinSeparator:WinSeparator"
	end,
})

vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter", "WinEnter", "TermOpen" }, {
	pattern = { "terminal", "help", "nofile", "prompt", "quickfix" },
	callback = function()
		vim.wo.statuscolumn = ""
		if vim.bo.buftype == "terminal" then
			vim.wo.number = false
			vim.wo.relativenumber = false
		end
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		vim.wo.number = false
		vim.wo.relativenumber = false
		vim.wo.statuscolumn = ""
	end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "FileType" }, {
	callback = function()
		if vim.bo.buftype == "" then
			vim.wo.statuscolumn = vim.o.statuscolumn
		end
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		if vim.bo.buftype ~= "" then
			return
		end
		vim.schedule(function()
			if vim.bo.buftype == "" then
				vim.o.statuscolumn = "%s %=%{&relativenumber && v:relnum ? v:relnum : v:lnum} %#Normal#%{repeat(' ', 1)}"
				vim.wo.statuscolumn = vim.o.statuscolumn
			end
		end)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "NvMenu",
	callback = function()
		vim.wo.winblend = 10
		vim.wo.winhl = "Normal:NvMenuNormal,FloatBorder:NvMenuBorder"
	end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
	callback = function()
		if vim.bo.buftype ~= "" then
			vim.wo.statuscolumn = ""
		end
	end,
})


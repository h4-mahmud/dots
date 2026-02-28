local M = {}

local function is_floating_win(win)
	local cfg = vim.api.nvim_win_get_config(win)
	return cfg and cfg.relative and cfg.relative ~= ""
end


local function setup_nvmenu_autocmds()
	-- Ensure menu buffers show a visible hover/selection line
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "NvMenu",
		callback = function()
			vim.opt_local.cursorline = true
			vim.opt_local.cursorlineopt = "line"
			vim.wo.winhighlight = "CursorLine:CursorLine,Normal:NormalFloat,FloatBorder:FloatBorder"
			vim.bo.bufhidden = "wipe"
			-- Disable underline highlights in menu buffers
			vim.b.illuminate_disable = true
			vim.b.matchparen_disable = 1
			pcall(function()
				require("illuminate").pause()
			end)

			-- Close menus when leaving the menu window or losing focus.
			vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
				buffer = 0,
				callback = function()
					vim.defer_fn(function()
						local ok_state, menu_state = pcall(require, "menu.state")
						if ok_state and menu_state.bufids then
							local cur = vim.api.nvim_get_current_buf()
							if vim.tbl_contains(menu_state.bufids, cur) then
								return
							end
						end
						for _, win in ipairs(vim.api.nvim_list_wins()) do
							local b = vim.api.nvim_win_get_buf(win)
							if vim.bo[b].filetype == "NvMenu" then
								pcall(vim.api.nvim_win_close, win, true)
							end
						end
						pcall(function()
							require("menu.utils").delete_old_menus()
						end)
					end, 30)
				end,
			})

			local ok_state, menu_state = pcall(require, "menu.state")
			local ok_volt, volt = pcall(require, "volt")
			if ok_state and ok_volt then
				vim.api.nvim_create_autocmd("CursorMoved", {
					buffer = 0,
					callback = function()
						local buf = vim.api.nvim_get_current_buf()
						if not (menu_state.bufids and vim.tbl_contains(menu_state.bufids, buf)) then
							return
						end
						local row = vim.api.nvim_win_get_cursor(0)[1]
						vim.g.nvmark_hovered = row .. "menu" .. buf
						volt.redraw(buf, "items")
					end,
				})
			end
		end,
	})

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "NvMenu",
		callback = function()
			vim.wo.winblend = 0
			vim.wo.winhl = "Normal:NormalFloat,FloatBorder:FloatBorder"
		end,
	})
end

local function setup_dashboard_tabline_hide()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "snacks_dashboard", "dashboard", "nvdash" },
		callback = function()
			vim.g.TbTabsToggled = 1
			pcall(vim.cmd, "redrawtabline")
		end,
	})
end

local function open_context_menu_at(win, buf)
	local ft = vim.bo[buf].ft
	if is_floating_win(win) and ft ~= "snacks_explorer" and ft ~= "snacks_picker_list" then
		return
	end
	local options = "default"
	if ft == "NvimTree" then
		options = "nvimtree"
	elseif ft == "snacks_explorer" or ft == "snacks_picker_list" then
		options = "nvimtree"
	elseif ft == "qf" then
		options = "qf"
	elseif ft == "snacks_dashboard" or ft == "dashboard" or ft == "nvdash" then
		options = "dashboard"
	end
	require("menu").open(options, { border = true })
end

local function open_context_menu()
	require("menu.utils").delete_old_menus()
	local mouse = vim.fn.getmousepos()
	local win = (mouse.winid and mouse.winid ~= 0) and mouse.winid or vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_win_get_buf(win)
	open_context_menu_at(win, buf)
end

local function setup_menu_keymaps()
	-- Keyboard users (always use current window, not last mouse position)
	vim.keymap.set("n", "<leader>me", function()
		require("menu.utils").delete_old_menus()
		local win = vim.api.nvim_get_current_win()
		local buf = vim.api.nvim_win_get_buf(win)
		open_context_menu_at(win, buf)
	end, { desc = "Menu", noremap = true, silent = true, nowait = true })

	-- Ensure <C-m> works even when a buffer-local mapping (like dashboards) overrides it.
	vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
		pattern = { "snacks_dashboard", "dashboard", "nvdash" },
		callback = function()
			vim.schedule(function()
				vim.keymap.set(
					"n",
					"<leader>me",
					open_context_menu,
					{ desc = "Menu", noremap = true, silent = true, nowait = true, buffer = true }
				)
			end)
		end,
	})

	-- mouse users + nvimtree users!
	vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
		require("menu.utils").delete_old_menus()

		vim.cmd.exec('"normal! \\<RightMouse>"')

		-- clicked buf
		local mp = vim.fn.getmousepos()
		if mp.winid == 0 or mp.line == 0 then
			vim.cmd.exec('"normal! \\<LeftMouse>"')
			require("menu").open("tabline", { mouse = true, border = true })
			return
		end

		local buf = vim.api.nvim_win_get_buf(mp.winid)
		local ft = vim.bo[buf].ft
		if mp.winid ~= 0 and is_floating_win(mp.winid) and ft ~= "snacks_explorer" and ft ~= "snacks_picker_list" then
			return
		end
		local options = "default"
		if ft == "NvimTree" then
			options = "nvimtree"
		elseif ft == "snacks_explorer" or ft == "snacks_picker_list" then
			options = "nvimtree"
		elseif ft == "qf" then
			options = "qf"
		elseif ft == "snacks_dashboard" or ft == "dashboard" or ft == "nvdash" then
			options = "dashboard"
		end

		require("menu").open(options, { mouse = true, border = "true" })
	end, {})

	-- Visual selection menu (IDE-like minimal set)
	vim.keymap.set({ "v", "x" }, "<RightMouse>", function()
		require("menu.utils").delete_old_menus()
		vim.cmd.exec('"normal! \\<RightMouse>"')
		local mp = vim.fn.getmousepos()
		if mp.winid ~= 0 and is_floating_win(mp.winid) then
			return
		end
		require("menu").open("visual", { mouse = true, border = true })
	end, {})

	-- Visual mode menu on keyboard
	vim.keymap.set({ "v", "x" }, "<leader>o", function()
		require("menu.utils").delete_old_menus()
		if vim.fn.mode():match("[vV]") then
			vim.cmd("normal! gv")
		end
		require("menu").open("visual", { border = true })
	end, { desc = "Menu (Visual)" })

	vim.keymap.set("i", "<RightMouse>", function()
		require("menu.utils").delete_old_menus()
		vim.cmd.exec('"normal! \\<RightMouse>"')

		local mp = vim.fn.getmousepos()
		if mp.winid == 0 or mp.line == 0 then
			vim.cmd.exec('"normal! \\<LeftMouse>"')
			vim.cmd("stopinsert")
			require("menu").open("tabline", { mouse = true, border = "true" })
			return
		end

		local buf = vim.api.nvim_win_get_buf(mp.winid)
		local ft = vim.bo[buf].ft
		if mp.winid ~= 0 and is_floating_win(mp.winid) and ft ~= "snacks_explorer" and ft ~= "snacks_picker_list" then
			return
		end
		local options = "default"
		if ft == "NvimTree" then
			options = "nvimtree"
		elseif ft == "snacks_explorer" or ft == "snacks_picker_list" then
			options = "nvimtree"
		elseif ft == "qf" then
			options = "qf"
		elseif ft == "snacks_dashboard" or ft == "dashboard" or ft == "nvdash" then
			options = "dashboard"
		end
		vim.cmd("stopinsert")
		require("menu").open(options, { mouse = true, border = "true" })
	end, {})
end

local function get_visual_selection()
	local _, ls, cs = unpack(vim.fn.getpos("'<"))
	local _, le, ce = unpack(vim.fn.getpos("'>"))
	if ls == 0 or le == 0 then
		return ""
	end
	local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)
	if #lines == 0 then
		return ""
	end
	lines[1] = lines[1]:sub(cs)
	lines[#lines] = lines[#lines]:sub(1, ce)
	return table.concat(lines, "\n")
end

local function diag_toggle_setting(key)
	local cfg = vim.diagnostic.config()
	local val = not cfg[key]
	vim.diagnostic.config({ [key] = val })
end

local function is_snacks_explorer()
	local ft = vim.bo.filetype
	return ft == "snacks_explorer" or ft == "snacks_picker_list"
end

local function snacks_picker()
	local ok, picker = pcall(require, "snacks.picker")
	if not ok then
		return nil
	end
	local list = picker.get({ source = "explorer", tab = false })
	return list and list[1] or nil
end

local function snacks_action(action)
	local picker = snacks_picker()
	if not picker then
		return
	end
	pcall(picker.action, picker, action)
end

local function snacks_current_path()
	local picker = snacks_picker()
	if not picker then
		return nil
	end
	local item = picker:current()
	if not item then
		return nil
	end
	local ok, util = pcall(require, "snacks.picker.util")
	if ok and util.path then
		return util.path(item)
	end
	return item.file
end

local function snacks_current_dir()
	local picker = snacks_picker()
	if not picker then
		return nil
	end
	return picker:dir()
end

local function with_nt_node(action)
	local ft = vim.bo.filetype
	local ok, api = pcall(require, "nvim-tree.api")
	if not ok then
		if ft == "NvimTree" then
			vim.notify("nvim-tree.api not available", vim.log.levels.WARN)
		end
		return
	end
	local node = api.tree.get_node_under_cursor()
	if not node then
		if ft == "NvimTree" then
			vim.notify("No node under cursor", vim.log.levels.WARN)
		end
		return
	end
	return action(api, node)
end

local function tree_action(nvim_action, snacks_action_name)
	if is_snacks_explorer() then
		if snacks_action_name then
			snacks_action(snacks_action_name)
		end
		return
	end
	with_nt_node(nvim_action)
end

local function curbuf()
	return vim.api.nvim_get_current_buf()
end

local function close_current()
	require("nvchad.tabufline").close_buffer(curbuf())
end

local function close_all()
	require("nvchad.tabufline").closeAllBufs()
end

local function copy_path()
	local name = vim.api.nvim_buf_get_name(curbuf())
	if name ~= "" then
		vim.fn.setreg("+", name)
	end
end

local function reveal_in_tree()
	pcall(vim.cmd, "NvimTreeFindFile")
end

local function rename_buffer()
	local name = vim.api.nvim_buf_get_name(curbuf())
	local dir = name ~= "" and vim.fn.fnamemodify(name, ":h") or vim.fn.getcwd()
	vim.ui.input({ prompt = "Rename to: ", default = name }, function(new_name)
		if not new_name or new_name == "" or new_name == name then
			return
		end
		if not new_name:match("^/") then
			new_name = dir .. "/" .. new_name
		end
		local ok, err = pcall(vim.fn.rename, name, new_name)
		if not ok or err ~= 0 then
			vim.notify("Rename failed", vim.log.levels.ERROR)
			return
		end
		vim.cmd("edit " .. vim.fn.fnameescape(new_name))
	end)
end

local function buffer_info()
	local name = vim.api.nvim_buf_get_name(curbuf())
	local ft = vim.bo[0].filetype
	local enc = vim.bo[0].fileencoding ~= "" and vim.bo[0].fileencoding or vim.o.encoding
	local msg = string.format("File: %s\nType: %s\nEncoding: %s", name ~= "" and name or "[No Name]", ft, enc)
	vim.notify(msg, vim.log.levels.INFO)
end

local function new_file_prompt()
	vim.ui.input({ prompt = "New file name: " }, function(name)
		if not name or name == "" then
			return
		end
		vim.cmd("edit " .. vim.fn.fnameescape(name))
	end)
end

M.menus = {
	dashboard = {
		{ name = "  New File", hl = "ExGreen", cmd = "enew | startinsert", rtxt = "n" },
		{ name = "󰈔  Find File", hl = "ExGreen", cmd = function() Snacks.picker.files() end, rtxt = "f" },
		{ name = "󰋚  Recent Files", hl = "ExGreen", cmd = function() Snacks.picker.recent() end, rtxt = "r" },
		{ name = "󰍉  Live Grep", hl = "ExCyan", cmd = function() Snacks.picker.grep() end, rtxt = "g" },
		{ name = "󰓩  Projects", hl = "ExGreen", cmd = function() Snacks.picker.projects() end, rtxt = "p" },
		{ name = "separator" },
		{ name = "󰓩  Sessions", hl = "ExBlue", cmd = function() require("persistence").select() end, rtxt = "s" },
		{
			name = "  Config",
			hl = "ExBlue",
			cmd = function()
				vim.cmd("tabnew")
				local conf = vim.fn.stdpath("config")
				vim.cmd("tcd " .. conf .. " | e init.lua")
			end,
			rtxt = "c",
		},
		{ name = "separator" },
		{ name = "  Mason", hl = "ExBlue", cmd = "Mason", rtxt = "m" },
		{ name = "󰒲  Lazy", hl = "ExBlue", cmd = "Lazy", rtxt = "l" },
		{ name = "󰿅  Quit", hl = "ExRed", cmd = "qa", rtxt = "Q" },
	},
	default = {
		{
			name = "󰆏  Paste",
			hl = "ExGreen",
			cmd = function()
				vim.cmd('normal! "+p')
			end,
			rtxt = "p",
		},
		{ name = "󰒭  Select All", hl = "ExGreen", cmd = "<C-a>", rtxt = "<C-a>" },
		{
			name = "󰕌  Undo",
			hl = "ExYellow",
			cmd = "undo",
			rtxt = "u",
		},
		{
			name = "󰑎  Redo",
			hl = "ExYellow",
			cmd = "redo",
			rtxt = "U",
		},
		{ name = "separator" },
		{
			name = "  Lsp Actions",
			hl = "ExBlue",
			items = "lsp",
		},
		{
			name = "󱖫  Diagnostics",
			hl = "ExRed",
			items = "diagnostics",
		},
		{ name = "separator" },
		{
			name = "󰍉  Search/Replace",
			hl = "ExCyan",
			cmd = "<cmd>GrugFar<cr>",
			rtxt = "<leader>sr",
		},
		{
			name = "󰈔  Find Files",
			hl = "ExGreen",
			cmd = function()
				Snacks.picker.files()
			end,
			rtxt = "<leader>ff",
		},
		{
			name = "󰍉  Grep",
			hl = "ExCyan",
			cmd = function()
				Snacks.picker.grep()
			end,
			rtxt = "<leader>sg",
		},
		{ name = "separator" },
		{
			name = "  Edit Config",
			hl = "ExBlue",
			cmd = function()
				vim.cmd("tabnew")
				local conf = vim.fn.stdpath("config")
				vim.cmd("tcd " .. conf .. " | e init.lua")
			end,
			rtxt = "ed",
		},
		{
			name = "󰆏  Copy Content",
			hl = "ExGreen",
			cmd = "%y+",
			rtxt = "<C-c>",
		},
		{
			name = "󰆴  Delete Content",
			hl = "ExRed",
			cmd = "%d",
			rtxt = "dc",
		},
		{ name = "separator" },
		{
			name = "  Open in terminal",
			hl = "ExRed",
			cmd = function()
				local old_buf = require("menu.state").old_data.buf
				local old_bufname = vim.api.nvim_buf_get_name(old_buf)
				local old_buf_dir = vim.fn.fnamemodify(old_bufname, ":h")

				local cmd = "cd " .. old_buf_dir

				if vim.g.base46_cache then
					require("nvchad.term").new({ cmd = cmd, pos = "sp" })
				else
					vim.cmd("enew")
					vim.fn.termopen({ vim.o.shell, "-c", cmd .. " ; " .. vim.o.shell })
				end
			end,
		},
		{ name = "separator" },
		{
			name = "  Color Picker",
			cmd = function()
				require("minty.huefy").open()
			end,
		},
	},
	diagnostics = {
		{ name = "󱖫  Diagnostics (Trouble)", hl = "ExRed", cmd = "Trouble diagnostics toggle", rtxt = "<leader>xx" },
		{ name = "󱖫  Buffer Diagnostics", hl = "ExRed", cmd = "Trouble diagnostics toggle filter.buf=0", rtxt = "<leader>xX" },
		{ name = "separator" },
		{ name = "󰌶  Toggle Virtual Text", hl = "ExCyan", cmd = function() diag_toggle_setting("virtual_text") end, rtxt = "vt" },
		{ name = "󰘤  Toggle Signs", hl = "ExCyan", cmd = function() diag_toggle_setting("signs") end, rtxt = "sg" },
		{ name = "󰛩  Toggle Underline", hl = "ExCyan", cmd = function() diag_toggle_setting("underline") end, rtxt = "ul" },
		{ name = "separator" },
		{ name = "󰁯  Next Diagnostic", hl = "ExYellow", cmd = function() vim.diagnostic.goto_next() end, rtxt = "]d" },
		{ name = "󰁴  Prev Diagnostic", hl = "ExYellow", cmd = function() vim.diagnostic.goto_prev() end, rtxt = "[d" },
	},
	editor = {
		{ name = "󰈙  Highlight", hl = "ExYellow", cmd = 'normal! *', rtxt = "*" },
		{
			name = "󰒭  Select All",
			hl = "ExGreen",
			cmd = function()
				local ok, state = pcall(require, "menu.state")
				local buf = ok and state.old_data and state.old_data.buf or nil
				if buf and vim.api.nvim_buf_is_valid(buf) then
					vim.api.nvim_buf_call(buf, function()
						vim.cmd("normal! gg0VG$")
					end)
				else
					vim.cmd("normal! gg0VG$")
				end
			end,
			rtxt = "<C-a>",
		},
		{ name = "separator" },
		{ name = "  Lsp Actions", hl = "ExBlue", items = "lsp" },
		{ name = "󱖫  Diagnostics", hl = "ExRed", items = "diagnostics" },
		{
			name = "󰌶  Symbols",
			hl = "ExBlue",
			cmd = function()
				Snacks.picker.lsp_symbols()
			end,
			rtxt = "ss",
		},
		{ name = "󰍉  Search/Replace", hl = "ExCyan", cmd = "<cmd>GrugFar<cr>", rtxt = "<leader>sr" },
		{ name = "󰈔  Find Files", hl = "ExGreen", cmd = function() Snacks.picker.files() end, rtxt = "<leader>ff" },
		{
			name = "󰍉  Grep (Current File)",
			hl = "ExCyan",
			cmd = function()
				local file = vim.fn.expand("%:t")
				local dir = vim.fn.expand("%:p:h")
				Snacks.picker.grep({ cwd = dir, glob = file })
			end,
			rtxt = "<leader>fg",
		},
		{
			name = "  Open in Terminal",
			hl = "ExBlue",
			cmd = function()
				local old_buf = require("menu.state").old_data.buf
				local old_bufname = vim.api.nvim_buf_get_name(old_buf)
				local old_buf_dir = vim.fn.fnamemodify(old_bufname, ":h")

				local cmd = "cd " .. old_buf_dir

				if vim.g.base46_cache then
					require("nvchad.term").new({ cmd = cmd, pos = "sp" })
				else
					vim.cmd("enew")
					vim.fn.termopen({ vim.o.shell, "-c", cmd .. " ; " .. vim.o.shell })
				end
			end,
		},
		{
			name = "  Color Picker",
			hl = "ExYellow",
			cmd = function()
				require("minty.huefy").open()
			end,
		},
	},
	lsp = {
		{ name = "󰁍  Goto Definition", hl = "ExGreen", cmd = vim.lsp.buf.definition, rtxt = "gd" },
		{ name = "󰁍  Goto Declaration", hl = "ExGreen", cmd = vim.lsp.buf.declaration, rtxt = "gD" },
		{ name = "󰁍  Goto Implementation", hl = "ExGreen", cmd = vim.lsp.buf.implementation, rtxt = "gi" },
		{ name = "󰁍  Goto Type Definition", hl = "ExGreen", cmd = vim.lsp.buf.type_definition, rtxt = "gy" },
		{ name = "󰁮  References", hl = "ExCyan", cmd = vim.lsp.buf.references, rtxt = "gr" },
		{ name = "󰧑  Hover", hl = "ExCyan", cmd = vim.lsp.buf.hover, rtxt = "K" },
		{ name = "󰑕  Rename", hl = "ExYellow", cmd = vim.lsp.buf.rename, rtxt = "<leader>cr" },
		{ name = "separator" },
		{ name = "󰌵  Code Actions", hl = "ExBlue", cmd = vim.lsp.buf.code_action, rtxt = "<leader>ca" },
		{
			name = "󰉿  Format",
			hl = "ExBlue",
			cmd = function()
				local ok, conform = pcall(require, "conform")
				if ok then
					conform.format({ lsp_fallback = true })
				else
					vim.lsp.buf.format()
				end
			end,
			rtxt = "<leader>cf",
		},
		{ name = "separator" },
		{ name = "󰒋  Lsp Info", hl = "ExCyan", cmd = function()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if #clients == 0 then
				vim.notify("No LSP clients attached", vim.log.levels.INFO)
				return
			end
			local names = {}
			for _, c in ipairs(clients) do
				table.insert(names, c.name)
			end
			vim.notify("Active LSP: " .. table.concat(names, ", "), vim.log.levels.INFO)
		end, rtxt = "LSP" },
		{ name = "󰒓  Lsp Start", hl = "ExGreen", cmd = function()
			if vim.fn.exists(":LspStart") == 2 then
				vim.cmd("LspStart")
			else
				vim.notify("LspStart not available", vim.log.levels.WARN)
			end
		end, rtxt = ":LspStart" },
		{ name = "󰓴  Lsp Stop (Buffer)", hl = "ExRed", cmd = function()
			for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
				pcall(c.stop, c)
			end
		end, rtxt = ":LspStop" },
	},
	nvimtree = {
		{
			name = "󰈔  Find Files",
			hl = "ExGreen",
			cmd = function()
				Snacks.picker.files()
			end,
			rtxt = "ff",
		},
		{
			name = "󰍉  Live Grep",
			hl = "ExCyan",
			cmd = function()
				Snacks.picker.grep()
			end,
			rtxt = "sg",
		},
		{ name = "separator" },
		{
			name = "  New file",
			hl = "ExGreen",
			cmd = function()
				tree_action(function(api, node)
					api.fs.create(node)
				end, "explorer_add")
			end,
			rtxt = "a",
		},
		{
			name = "  New folder",
			hl = "ExGreen",
			cmd = function()
				tree_action(function(api, node)
					api.fs.create(node)
				end, "explorer_add")
			end,
			rtxt = "a",
		},
		{ name = "separator" },
		{
			name = "  Open in window",
			hl = "ExBlue",
			cmd = function()
				tree_action(function(api, node)
					api.node.open.edit(node)
				end, "confirm")
			end,
			rtxt = "o",
		},
		{
			name = "  Open in vertical split",
			hl = "ExBlue",
			cmd = function()
				tree_action(function(api, node)
					api.node.open.vertical(node)
				end, "vsplit")
			end,
			rtxt = "v",
		},
		{
			name = "  Open in horizontal split",
			hl = "ExBlue",
			cmd = function()
				tree_action(function(api, node)
					api.node.open.horizontal(node)
				end, "split")
			end,
			rtxt = "s",
		},
		{
			name = "󰓪  Open in new tab",
			hl = "ExBlue",
			cmd = function()
				tree_action(function(api, node)
					api.node.open.tab(node)
				end, "tab")
			end,
			rtxt = "O",
		},
		{ name = "separator" },
		{
			name = "  Cut",
			hl = "ExRed",
			cmd = function()
				tree_action(function(api, node)
					api.fs.cut(node)
				end, "explorer_move")
			end,
			rtxt = "x",
		},
		{
			name = "  Paste",
			hl = "ExGreen",
			cmd = function()
				tree_action(function(api, node)
					api.fs.paste(node)
				end, "explorer_paste")
			end,
			rtxt = "p",
		},
		{
			name = "  Copy",
			hl = "ExGreen",
			cmd = function()
				tree_action(function(api, node)
					api.fs.copy.node(node)
				end, "explorer_copy")
			end,
			rtxt = "c",
		},
		{
			name = "󰴠  Copy absolute path",
			hl = "ExGreen",
			cmd = function()
				if is_snacks_explorer() then
					local path = snacks_current_path()
					if path then
						vim.fn.setreg("+", path)
					end
					return
				end
				with_nt_node(function(api, node)
					api.fs.copy.absolute_path(node)
				end)
			end,
			rtxt = "gy",
		},
		{
			name = "  Copy relative path",
			hl = "ExGreen",
			cmd = function()
				if is_snacks_explorer() then
					local path = snacks_current_path()
					if path then
						local rel = vim.fn.fnamemodify(path, ":.")
						vim.fn.setreg("+", rel)
					end
					return
				end
				with_nt_node(function(api, node)
					api.fs.copy.relative_path(node)
				end)
			end,
			rtxt = "Y",
		},
		{
			name = "󰈔  Copy filename",
			hl = "ExGreen",
			cmd = function()
				if is_snacks_explorer() then
					local path = snacks_current_path()
					if path then
						vim.fn.setreg("+", vim.fn.fnamemodify(path, ":t"))
					end
					return
				end
				with_nt_node(function(_, node)
					local p = node.absolute_path
					if p then
						vim.fn.setreg("+", vim.fn.fnamemodify(p, ":t"))
					end
				end)
			end,
			rtxt = "yf",
		},
		{
			name = "󰈢  Copy directory path",
			hl = "ExGreen",
			cmd = function()
				if is_snacks_explorer() then
					local path = snacks_current_path()
					if path then
						local dir = vim.fn.fnamemodify(path, ":h")
						vim.fn.setreg("+", dir)
					end
					return
				end
				with_nt_node(function(_, node)
					local p = node.absolute_path
					if p then
						local dir = vim.fn.fnamemodify(p, ":h")
						vim.fn.setreg("+", dir)
					end
				end)
			end,
			rtxt = "yd",
		},
		{ name = "separator" },
		{
			name = "  Open in terminal",
			hl = "ExBlue",
			hl = "ExBlue",
			cmd = function()
				if is_snacks_explorer() then
					local path = snacks_current_path() or snacks_current_dir()
					if not path or path == "" then
						return
					end
					local stat = vim.uv.fs_stat(path)
					local node_type = stat and stat.type or nil
					local dir = node_type == "directory" and path or vim.fn.fnamemodify(path, ":h")
					if dir == "" then
						return
					end
					vim.cmd("enew")
					vim.fn.termopen({ vim.o.shell, "-c", "cd " .. dir .. " ; " .. vim.o.shell })
					return
				end
				with_nt_node(function(_, node)
					local path = node.absolute_path
					local stat = path and vim.uv.fs_stat(path) or nil
					local node_type = stat and stat.type or nil
					local dir = node_type == "directory" and path or vim.fn.fnamemodify(path or "", ":h")

					if dir == "" then
						return
					end

					vim.cmd("enew")
					vim.fn.termopen({ vim.o.shell, "-c", "cd " .. dir .. " ; " .. vim.o.shell })
				end)
			end,
		},
		{
			name = "󰗼  Reveal in file manager",
			hl = "ExBlue",
			cmd = function()
				if is_snacks_explorer() then
					local path = snacks_current_path()
					if path then
						vim.ui.open(path)
					end
					return
				end
				with_nt_node(function(_, node)
					local path = node.absolute_path
					if path then
						vim.ui.open(path)
					end
				end)
			end,
		},
		{ name = "separator" },
		{
			name = "  Rename",
			hl = "ExYellow",
			cmd = function()
				tree_action(function(api, node)
					api.fs.rename(node)
				end, "explorer_rename")
			end,
			rtxt = "r",
		},
		{
			name = "  Trash",
			hl = "ExRed",
			cmd = function()
				tree_action(function(api, node)
					api.fs.trash(node)
				end, "explorer_del")
			end,
			rtxt = "D",
		},
		{
			name = "  Delete",
			hl = "ExRed",
			hl = "ExRed",
			cmd = function()
				tree_action(function(api, node)
					api.fs.remove(node)
				end, "explorer_del")
			end,
			rtxt = "d",
		},
		{ name = "separator" },
		{
			name = "󰛫  Refresh tree",
			hl = "ExCyan",
			cmd = function()
				if is_snacks_explorer() then
					snacks_action("explorer_update")
					return
				end
				local api = require("nvim-tree.api")
				api.tree.reload()
			end,
			rtxt = "R",
		},
		{
			name = "󰒴  Collapse all",
			hl = "ExCyan",
			cmd = function()
				if is_snacks_explorer() then
					snacks_action("explorer_close_all")
					return
				end
				local api = require("nvim-tree.api")
				api.tree.collapse_all()
			end,
			rtxt = "C",
		},
	},
	qf = {
		{ name = "󰁯  Next", cmd = "cnext", rtxt = "]q" },
		{ name = "󰁴  Prev", cmd = "cprev", rtxt = "[q" },
		{ name = "separator" },
		{ name = "󰁫  First", cmd = "cfirst", rtxt = "cf" },
		{ name = "󰁮  Last", cmd = "clast", rtxt = "cl" },
		{ name = "separator" },
		{ name = "󰗽  Open", cmd = "copen", rtxt = "co" },
		{ name = "󰅖  Close", cmd = "cclose", rtxt = "cc" },
		{ name = "󰅘  Clear", cmd = "cexpr []", rtxt = "cX" },
	},
	snacks = {
		{ name = "󰈔  Find Files", hl = "ExGreen", cmd = function() Snacks.picker.files() end, rtxt = "ff" },
		{ name = "󰍉  Grep", hl = "ExCyan", cmd = function() Snacks.picker.grep() end, rtxt = "sg" },
		{ name = "󰈢  Buffers", hl = "ExGreen", cmd = function() Snacks.picker.buffers() end, rtxt = "fb" },
		{ name = "󰋚  Recent", hl = "ExGreen", cmd = function() Snacks.picker.recent() end, rtxt = "fr" },
		{ name = "󰒓  Commands", hl = "ExBlue", cmd = function() Snacks.picker.commands() end, rtxt = ":" },
		{ name = "separator" },
		{ name = "󰌶  LSP Symbols", hl = "ExBlue", cmd = function() Snacks.picker.lsp_symbols() end, rtxt = "ss" },
		{ name = "󰌷  Workspace Symbols", hl = "ExBlue", cmd = function() Snacks.picker.lsp_workspace_symbols() end, rtxt = "sS" },
		{ name = "separator" },
		{ name = "󰊢  Git Status", hl = "ExYellow", cmd = function() Snacks.picker.git_status() end, rtxt = "gs" },
		{ name = "󰏖  Git Log", hl = "ExYellow", cmd = function() Snacks.picker.git_log() end, rtxt = "gl" },
	},
	tabline = {
		{ name = "󰈔  New File", hl = "ExGreen", cmd = new_file_prompt, rtxt = "n" },
		{ name = "󰑕  Rename File", hl = "ExYellow", cmd = rename_buffer, rtxt = "R" },
		{ name = "󰋽  File Info", hl = "ExCyan", cmd = buffer_info, rtxt = "i" },
		{ name = "󰆏  Copy FilePath", hl = "ExGreen", cmd = copy_path, rtxt = "y" },
		{ name = "separator" },
		{ name = "  Vertical Split", hl = "ExBlue", cmd = "vsplit", rtxt = "v" },
		{ name = "  Horizontal Split", hl = "ExBlue", cmd = "split", rtxt = "s" },
		{ name = "󰓩  New Tab", hl = "ExGreen", cmd = "tabnew", rtxt = "t" },
		{ name = "separator" },
		{ name = "󰙅  File Explorer", hl = "ExBlue", cmd = reveal_in_tree, rtxt = "e" },
		{ name = "󰈔  Find Files", hl = "ExGreen", cmd = function() Snacks.picker.files() end, rtxt = "f" },
		{ name = "󰍉  Live Grep", hl = "ExCyan", cmd = function() Snacks.picker.grep() end, rtxt = "g" },
		{ name = "separator" },
		{ name = "󰅖  Close All Files", hl = "ExRed", cmd = close_all, rtxt = "a" },
		{ name = "󰆴  Close File", hl = "ExRed", cmd = close_current, rtxt = "x" },
	},
	visual = {
		{ name = "󰆐  Cut", hl = "ExRed", cmd = 'normal! "+d', rtxt = "x" },
		{ name = "󰆏  Copy", hl = "ExGreen", cmd = 'normal! "+y', rtxt = "y" },
		{ name = "󰆏  Paste", hl = "ExGreen", cmd = 'normal! "+p', rtxt = "p" },
		{
			name = "󰒭  Select All",
			hl = "ExGreen",
			cmd = function()
				local ok, state = pcall(require, "menu.state")
				local buf = ok and state.old_data and state.old_data.buf or nil
				if buf and vim.api.nvim_buf_is_valid(buf) then
					vim.api.nvim_buf_call(buf, function()
						vim.cmd("normal! gg0VG$")
					end)
				else
					vim.cmd("normal! gg0VG$")
				end
			end,
			rtxt = "<C-a>",
		},
		{ name = "󰕌  Undo", hl = "ExYellow", cmd = "undo", rtxt = "u" },
		{ name = "󰑎  Redo", hl = "ExYellow", cmd = "redo", rtxt = "U" },
		{ name = "separator" },
		{ name = "  Highlight", hl = "ExBlue", cmd = 'normal! "*', rtxt = "*" },
		{
			name = "󰍉  Grep (Selection)",
			hl = "ExCyan",
			cmd = function()
				local text = get_visual_selection()
				if text ~= "" then
					Snacks.picker.grep({ search = text })
				end
			end,
			rtxt = "<leader>sg",
		},
		{
			name = "󰍉  Search/Replace (Selection)",
			hl = "ExCyan",
			cmd = function()
				local text = get_visual_selection()
				if text ~= "" then
					require("grug-far").open({
						prefills = {
							search = text,
						},
					})
				end
			end,
			rtxt = "<leader>sr",
		},
	},
}

function M.register()
	for name, items in pairs(M.menus) do
		package.preload["menus." .. name] = function()
			return items
		end
	end
end

function M.setup()
	M.register()
	setup_nvmenu_autocmds()
	setup_menu_keymaps()
	setup_dashboard_tabline_hide()
end

return M

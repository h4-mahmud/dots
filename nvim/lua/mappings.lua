require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set
map("n", ";", ":", { desc = "CMD enter command mode" })

map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><Esc>", { desc = "Save File" })

map("i", "jk", "<ESC>")
map("n", "<leader>fq", "<cmd>qall!<cr>", { desc = "Force Quit" })
map({ "v", "n" }, "<C-q>", "<cmd>q<cr>", { desc = "Exit Vim" })
map({ "v", "n" }, "<C-S-q>", "<cmd>q!<cr>", { desc = "Exit Vim" })
map({ "n" }, "<leader>o", "<cmd>Oil<cr>", { desc = "Open Oil in the current Directory" })

-- Toggle tiny-inline-diagnostic: all lines vs cursor line
-- map("n", "<leader>xm","<cmd>TinyInlineDiag toggle_all_diags_on_cursorline<cr>",{ desc = "Toggle Inline Diags (All Lines)" })

map("n", "<leader>x", "<Nop>", { desc = "Leader X Prefix" })
map("n", "<leader>xc", "<cmd>bdelete<cr>", { desc = "Close Buffer" })

-- Ctrl+Backspace deletes previous word in insert mode
map("i", "<C-BS>", "<C-w>", { desc = "Delete Word Backward" })

-- NvChad mappings.lua
local opts = { noremap = true, silent = true }

-- Select All (Ctrl+A)
map("n", "<C-a>", "gg0VG$", vim.tbl_extend("force", opts, { desc = "Select All" }))

-- Cut Line (Ctrl+X like VSCode)
map({ "n", "v" }, "<C-x>", "dd", vim.tbl_extend("force", opts, { desc = "Cut Line" }))
map("i", "<C-x>", "<C-o>dd", vim.tbl_extend("force", opts, { desc = "Cut Line (Insert)" }))

-- map("v","p","P")

-- Copy Line (Ctrl+C)
map({ "n", "v" }, "<C-c>", "yy", vim.tbl_extend("force", opts, { desc = "Copy Line" }))
map("i", "<C-c>", "<C-o>yy", vim.tbl_extend("force", opts, { desc = "Copy Line (Insert)" }))

-- Undo / Redo
map({ "n", "v" }, "<C-z>", "u", vim.tbl_extend("force", opts, { desc = "Undo" }))
map({ "n", "v" }, "<C-y>", "<C-r>", vim.tbl_extend("force", opts, { desc = "Redo" }))
map("i", "<C-z>", "<C-o>u", vim.tbl_extend("force", opts, { desc = "Undo (Insert)" }))
map("i", "<C-y>", "<C-o><C-r>", vim.tbl_extend("force", opts, { desc = "Redo (Insert)" }))

-- Move line/block Up & Down (Alt+Up / Alt+Down)
map("n", "<A-Down>", ":m .+1<CR>==", vim.tbl_extend("force", opts, { desc = "Move Line Down" }))
map("n", "<A-Up>", ":m .-2<CR>==", vim.tbl_extend("force", opts, { desc = "Move Line Up" }))
map("i", "<A-Down>", "<Esc>:m .+1<CR>==gi", vim.tbl_extend("force", opts, { desc = "Move Line Down (Insert)" }))
map("i", "<A-Up>", "<Esc>:m .-2<CR>==gi", vim.tbl_extend("force", opts, { desc = "Move Line Up (Insert)" }))
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", vim.tbl_extend("force", opts, { desc = "Move Selection Down" }))
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", vim.tbl_extend("force", opts, { desc = "Move Selection Up" }))

map("n", "<A-j>", ":m .+1<CR>==", vim.tbl_extend("force", opts, { desc = "Move Line Down" }))
map("n", "<A-k>", ":m .-2<CR>==", vim.tbl_extend("force", opts, { desc = "Move Line Up" }))
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", vim.tbl_extend("force", opts, { desc = "Move Line Down (Insert)" }))
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", vim.tbl_extend("force", opts, { desc = "Move Line Up (Insert)" }))
map("v", "<A-j>", ":m '>+1<CR>gv=gv", vim.tbl_extend("force", opts, { desc = "Move Selection Down" }))
map("v", "<A-k>", ":m '<-2<CR>gv=gv", vim.tbl_extend("force", opts, { desc = "Move Selection Up" }))

-- Copy line down (Ctrl+Shift+Down)
map("n", "<A-S-j>", "yyp", vim.tbl_extend("force", opts, { desc = "Duplicate Line Down" }))
map("n", "<A-S-k>", "yyP", vim.tbl_extend("force", opts, { desc = "Duplicate Line Up" }))
map("v", "<A-S-j>", "y'>p", vim.tbl_extend("force", opts, { desc = "Duplicate Selection Down" }))
map("v", "<A-S-k>", "y'<P", vim.tbl_extend("force", opts, { desc = "Duplicate Selection Up" }))

local cmp = require("cmp")
local ok_luasnip, luasnip = pcall(require, "luasnip")

cmp.setup({
	mapping = {
		-- Confirm selection
		["<CR>"] = cmp.mapping.confirm({ select = true }),

		-- Abort menu when using navigation keys
		["<Down>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<Up>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { "i", "s" }),

		-- Abort menu when moving sideways
		["<Left>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.abort()
			end
			fallback()
		end, { "i", "s" }),

		["<Right>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.abort()
			end
			fallback()
		end, { "i", "s" }),

		-- Abort menu on Esc without leaving insert if visible
		["<Esc>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.abort()
			else
				fallback()
			end
		end, { "i", "s" }),

		-- Navigate menu with Tab / Shift-Tab
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif ok_luasnip and luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif ok_luasnip and luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),

		-- Ctrl+A: close popup but stay in insert mode
		["<A>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.abort() -- closes menu only
			else
				fallback() -- normal Ctrl+A (select all, or start of line)
			end
		end, { "i", "s" }),
	},
})

map({ "v", "n", "i" }, "<C-f>", "<esc>:%s/", { desc = "Search & Replace" })
map({ "v", "n" }, "<C-`>", ":terminal", { desc = "Open Terminal" })
map("v", "d", '"_di', { noremap = true, desc = "Delete Without Yanking" })

-- Resize splits with Ctrl+Alt+H/J/K/L
map("n", "<C-M-h>", "<cmd>vertical resize +2<cr>", { desc = "Resize Left" })
map("n", "<C-M-l>", "<cmd>vertical resize -2<cr>", { desc = "Resize Right" })
map("n", "<C-M-j>", "<cmd>resize -2<cr>", { desc = "Resize Down" })
map("n", "<C-M-k>", "<cmd>resize +2<cr>", { desc = "Resize Up" })

-- local function focus_or_open_snacks_explorer()
-- 	local target_win = nil
-- 	for _, win in ipairs(vim.api.nvim_list_wins()) do
-- 		local buf = vim.api.nvim_win_get_buf(win)
-- 		local ft = vim.bo[buf].filetype
-- 		if ft == "snacks_explorer" or ft == "snacks_picker_list" then
-- 			target_win = win
-- 			break
-- 		end
-- 	end
--
-- 	if target_win then
-- 		vim.api.nvim_set_current_win(target_win)
-- 		return
-- 	end
--
-- 	require("snacks").explorer()
-- 	vim.schedule(function()
-- 		for _, win in ipairs(vim.api.nvim_list_wins()) do
-- 			local buf = vim.api.nvim_win_get_buf(win)
-- 			local ft = vim.bo[buf].filetype
-- 			if ft == "snacks_explorer" or ft == "snacks_picker_list" then
-- 				vim.api.nvim_set_current_win(win)
-- 				return
-- 			end
-- 		end
-- 	end)
-- end
--
-- map("n", "<leader>e", focus_or_open_snacks_explorer, { desc = "Focus/Open Snacks Explorer" })

map("n", "<leader>tw", "<cmd>Twilight<cr>", { desc = "Toggle Twilight Mode" })

local function icons_picker()
	local ok_tel, builtin = pcall(require, "telescope.builtin")
	if ok_tel and builtin.symbols then
		local ok = pcall(builtin.symbols)
		if ok then
			return
		end
	end
	local ok_snacks, snacks = pcall(require, "snacks")
	if ok_snacks and snacks.picker and snacks.picker.icons then
		snacks.picker.icons()
	end
end

map("n", "<leader>si", icons_picker, { desc = "Icons (Snacks/Telescope)" })

map("n", "<leader>gh", "<cmd>Gitsigns preview_hunk_inline<cr>", { desc = "Hunk (Inline)" })
map("n", "<leader>gv", "<cmd>Gitsigns select_hunk<cr>", { desc = "Select Hunk" })
map("n", "<leader>ge", "<cmd>Gitsigns diffthis<cr>", { desc = "Diff This" })
map("n", "<leader>gH", "<cmd>Gitsigns show<cr>", { desc = "Time Travel" })
map("n", "<leader>g[", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Previous Hunk" })
map("n", "<leader>g]", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Next Hunk" })
map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset Hunk" })
map("n", "<leader>cl", "<cmd>checktime<cr>", { desc = "Reload" })

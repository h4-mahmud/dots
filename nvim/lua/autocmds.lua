require "nvchad.autocmds"

local function is_diagnostic_float(win, buf)
	local cfg = vim.api.nvim_win_get_config(win)
	if not (cfg and cfg.relative and cfg.relative ~= "") then
		return false
	end
	if vim.bo[buf].buftype ~= "nofile" or vim.bo[buf].filetype ~= "markdown" then
		return false
	end
	local first_line = (vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""):gsub("%s+$", "")
	return first_line:match("^Diagnostics") ~= nil
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
	callback = function()
		local win = vim.api.nvim_get_current_win()
		local buf = vim.api.nvim_get_current_buf()
		if not is_diagnostic_float(win, buf) then
			return
		end
		vim.keymap.set("n", "<CR>", function()
			local prev_win = vim.fn.win_getid(vim.fn.winnr("#"))
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
			if prev_win ~= 0 and vim.api.nvim_win_is_valid(prev_win) then
				vim.api.nvim_set_current_win(prev_win)
				vim.diagnostic.goto_next({ float = false })
			end
		end, { buffer = buf, silent = true, desc = "Jump to diagnostic" })
	end,
})

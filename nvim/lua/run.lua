local M = {}

local function open_float_term(cmd)
	local buf = vim.api.nvim_create_buf(false, true)
	local term_cfg = require("nvconfig").term or {}
	local float_opts = vim.tbl_deep_extend("force", term_cfg.float or {}, {})

	float_opts.width = math.ceil(float_opts.width * vim.o.columns)
	float_opts.height = math.ceil(float_opts.height * vim.o.lines)
	float_opts.row = math.ceil(float_opts.row * vim.o.lines)
	float_opts.col = math.ceil(float_opts.col * vim.o.columns)
	float_opts.relative = float_opts.relative or "editor"
	float_opts.style = float_opts.style or "minimal"
	float_opts.border = float_opts.border or "single"

	local win = vim.api.nvim_open_win(buf, true, float_opts)
	vim.bo[buf].buflisted = false

	local winopts = vim.tbl_deep_extend("force", term_cfg.winopts or {}, {})
	for k, v in pairs(winopts) do
		vim.wo[win][k] = v
	end

	local job_id = vim.fn.termopen({ vim.o.shell, "-c", cmd }, {
		on_exit = function(_, code)
			vim.schedule(function()
				if vim.api.nvim_buf_is_valid(buf) and job_id then
					vim.api.nvim_chan_send(job_id, ("\n[exit %d]\n"):format(code))
				end
			end)
		end,
	})

	if term_cfg.startinsert then
		vim.cmd("startinsert")
	end
end

local function runner_cmd(file)
	local ft = vim.bo.filetype

	local cmds = {
		python = "python3 " .. file,
		c = "tcc -run " .. file,
		cpp = "g++ " .. file .. " -O2 -o /tmp/a.out && /tmp/a.out",
		sh = "bash " .. file,
		lua = "lua " .. file,
		javascript = "node " .. file,
		typescript = "node " .. file,
		go = "go run " .. file,
		rust = "cargo run",
	}

	return cmds[ft]
end

function M.run()
	local tmp = vim.fn.tempname()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	vim.fn.writefile(lines, tmp)

	local file = vim.fn.shellescape(tmp)
	local cmd = runner_cmd(file)
	if not cmd then
		vim.notify("No runner for " .. vim.bo.filetype, vim.log.levels.WARN)
		return
	end

	open_float_term(cmd)
end

vim.keymap.set("n", "<leader>R", M.run, { noremap = true, silent = true, desc = "Run current file" })

return M

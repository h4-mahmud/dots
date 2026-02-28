return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = "VeryLazy",
        opts = {
            indent = { char = "│" },
            scope = { enabled = false }, -- do NOT conflict with mini.indentscope
            exclude = {
                filetypes = {
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
            },
        },
    },
    {
        "echasnovski/mini.indentscope",

        -- Load only for real code buffers
        ft = {
            "lua",
            "vim",
            "vimdoc",
            "c",
            "cpp",
            "objc",
            "objcpp",
            "rust",
            "go",
            "zig",
            "python",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "java",
            "kotlin",
            "scala",
            "swift",
            "sh",
            "bash",
            "zsh",
            "fish",
            "html",
            "css",
            "scss",
            "sass",
            "less",
            "json",
            "yaml",
            "toml",
            "xml",
            "sql",
            "make",
            "cmake",
            "dockerfile",
            "gitconfig",
            "haskell",
            "ocaml",
            "elixir",
            "erlang",
            "clojure",
            "scheme",
            "lisp",
            "nix",
        },

        opts = {
            symbol = "│",
            options = { try_as_border = true },
            animation = function()
                return 6
            end, -- lower = faster
        },
    },
    {
        "rachartier/tiny-glimmer.nvim",
        event = "VeryLazy",
        opts = {
            disable_warnings = true,
            refresh_interval_ms = 12,
            overwrite = {
                auto_map = true,
                yank = { enabled = true, default_animation = "rainbow" },
                paste = { enabled = true, default_animation = "rainbow" },
                search = { enabled = true, default_animation = "rainbow" },
                undo = { enabled = true, default_animation = { name = "rainbow" } },
                redo = { enabled = true, default_animation = { name = "rainbow" } },
            },
            animations = {
                rainbow = {
                    max_duration = 500,
                    min_duration = 280,
                    chars_for_max_duration = 20,
                    font_style = {},
                },
            },
        },
    },
    {
        "gen740/SmoothCursor.nvim",
        event = "VeryLazy",
        opts = {
            type = "default",
            cursor = "",
            texthl = "SmoothCursor",
            linehl = nil,
            fancy = {
                enable = true,
                head = { cursor = "", texthl = "SmoothCursor", linehl = nil },
                body = {
                    { cursor = "󰝥", texthl = "SmoothCursorRed" },
                    { cursor = "󰝥", texthl = "SmoothCursorOrange" },
                    { cursor = "●", texthl = "SmoothCursorYellow" },
                    { cursor = "●", texthl = "SmoothCursorGreen" },
                    { cursor = "•", texthl = "SmoothCursorAqua" },
                    { cursor = ".", texthl = "SmoothCursorBlue" },
                    { cursor = ".", texthl = "SmoothCursorPurple" },
                },
                tail = { cursor = nil, texthl = "SmoothCursor" },
            },
            matrix = nil,
            autostart = true,
            always_redraw = true,
            speed = 25,
            intervals = 35,
            priority = 10,
            timeout = 3000,
            threshold = 3,
            disable_float_win = false,
            disabled_filetypes = { "dashboard", "nvdash", "snacks_dashboard" },
        },
        config = function(_, opts)
            vim.api.nvim_set_hl(0, "SmoothCursorRed", { fg = "#ff5f5f" })
            vim.api.nvim_set_hl(0, "SmoothCursorOrange", { fg = "#ffaf5f" })
            vim.api.nvim_set_hl(0, "SmoothCursorYellow", { fg = "#ffd75f" })
            vim.api.nvim_set_hl(0, "SmoothCursorGreen", { fg = "#5fff87" })
            vim.api.nvim_set_hl(0, "SmoothCursorAqua", { fg = "#5fffff" })
            vim.api.nvim_set_hl(0, "SmoothCursorBlue", { fg = "#5f87ff" })
            vim.api.nvim_set_hl(0, "SmoothCursorPurple", { fg = "#af5fff" })
            vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#ffd400" })

            require("smoothcursor").setup(opts)
        end,
    },

    ------------------------------------------------------------------
    -- Smear Cursor (disable mini.animate cursor)
    ------------------------------------------------------------------
    -- {
    -- 	"sphamba/smear-cursor.nvim",
    -- 	event = "VeryLazy",
    -- 	cond = function()
    -- 		return vim.g.neovide == nil
    -- 	end,
    -- 	opts = {
    -- 		hide_target_hack = true,
    -- 		cursor_color = "none",
    -- 	},
    -- 	dependencies = {
    -- 		{
    -- 			"nvim-mini/mini.animate",
    -- 			optional = true,
    -- 			opts = {
    -- 				cursor = { enable = false },
    -- 			},
    -- 		},
    -- 	},
    -- },

    {
        "cxwx/specs.nvim",
        event = "VeryLazy",
        opts = {
            show_jumps = true,
            min_jump = 10,
            popup = {
                delay_ms = 0,
                inc_ms = 6,
                blend = 0,
                width = 20,
                winhl = "SpecsRed",
            },
            ignore_filetypes = { "NvimTree", "TelescopePrompt", "lazy" },
            ignore_buftypes = { "terminal", "nofile" },
        },
        config = function(_, opts)
            vim.api.nvim_set_hl(0, "SpecsRed", { bg = "#ff5f5f", fg = "#3a1515", bold = true })
            vim.api.nvim_set_hl(0, "SpecsOrange", { bg = "#ffaf5f", fg = "#3a2515", bold = true })
            vim.api.nvim_set_hl(0, "SpecsYellow", { bg = "#ffd75f", fg = "#3a3315", bold = true })
            vim.api.nvim_set_hl(0, "SpecsGreen", { bg = "#5fff87", fg = "#153a21", bold = true })
            vim.api.nvim_set_hl(0, "SpecsAqua", { bg = "#5fffff", fg = "#153a3a", bold = true })
            vim.api.nvim_set_hl(0, "SpecsBlue", { bg = "#5f87ff", fg = "#15263a", bold = true })
            vim.api.nvim_set_hl(0, "SpecsPurple", { bg = "#af5fff", fg = "#2a153a", bold = true })

            local specs = require("specs")
            opts.popup.fader = specs.exp_fader
            opts.popup.resizer = specs.shrink_resizer
            specs.setup(opts)

            local cycle = {
                "SpecsRed",
                "SpecsOrange",
                "SpecsYellow",
                "SpecsGreen",
                "SpecsAqua",
                "SpecsBlue",
                "SpecsPurple",
            }

            local idx = 1
            local original = specs.show_specs

            specs.show_specs = function(overrides)
                overrides = overrides or {}
                overrides.winhl = cycle[idx]
                idx = (idx % #cycle) + 1
                return original(overrides)
            end
        end,
    },
}

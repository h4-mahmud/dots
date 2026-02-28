return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter",
                opts = function(_, opts)
                    opts = opts or {}
                    opts.ensure_installed = opts.ensure_installed or {}
                    for _, parser in ipairs({ "markdown", "markdown_inline", "latex" }) do
                        if not vim.tbl_contains(opts.ensure_installed, parser) then
                            table.insert(opts.ensure_installed, parser)
                        end
                    end
                    return opts
                end,
            },
            "nvim-tree/nvim-web-devicons",
        },
        ft = { "markdown", "codecompanion" },
        opts = {
            latex = {
                enabled = true,
                -- Prefer tiny Debian package backend; keep utftex as fallback.
                converter = { "latex2text", "utftex" },
            },
        },
    },

    {
        "lervag/vimtex",
        ft = { "tex", "plaintex", "latex" },
        init = function()
            -- If on Linux ARM (Raspberry Pi/Pinebook), use zathura.
            -- If on MacOS ARM (M1/M2/M3), change this to 'skim'.
            vim.g.vimtex_view_method = "zathura"
            vim.g.vimtex_compiler_method = "tectonic"
            vim.g.vimtex_quickfix_mode = 0
        end,
    },

    {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        opts = function(_, opts)
            opts = opts or {}
            opts.servers = opts.servers or {}
            opts.servers.texlab = opts.servers.texlab or {}
            opts.servers.texlab.settings = {
                texlab = {
                    build = {
                        executable = "tectonic",
                        args = { "%f", "--synctex", "--keep-logs", "--keep-intermediates" },
                        onSave = true,
                    },
                    forwardSearch = {
                        executable = "zathura",
                        args = { "%p", "%l" },
                    },
                },
            }
            return opts
        end,
    },
    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        opts = {
            window = {
                backdrop = 0.95, -- Dims the background
                width = 100,     -- Centers the text
                options = {
                    signcolumn = "no",
                    number = false,
                    relativenumber = false,
                    cursorline = false,
                },
            },
            plugins = {
                options = { enabled = true, ruler = false, showcmd = false },
                twilight = { enabled = true }, -- Dims surrounding text
            },
        },
        keys = {
            { "<leader>zm", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
        },
    },
    "folke/twilight.nvim",
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
}

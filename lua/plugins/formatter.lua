return {
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "williamboman/mason.nvim",
            "jay-babu/mason-null-ls.nvim",
        },
        config = function()
            local null_ls = require("null-ls")
            local mason_null_ls = require("mason-null-ls")

            -- 1. Setup Mason first
            require("mason").setup()

            -- 2. Setup Mason-Null-Ls (Bridge between Mason and None-ls)
            mason_null_ls.setup({
                ensure_installed = {
                    "prettier",
                    "stylua",
                    "black",
                    "shfmt",
                    "clang_format",
                },
                automatic_installation = true,
                handlers = {}, -- This is the key fix to prevent the 'validate' error
            })

            -- 3. Setup None-Ls (Actual Formatter Config)
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.prettier,
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.shfmt,
                    null_ls.builtins.formatting.clang_format,
                },
                -- Auto-format on SAVE (Standard & Safer than on Quit)
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
                        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = bufnr, async = false })
                            end,
                        })
                    end
                end,
            })
        end,
    },
}

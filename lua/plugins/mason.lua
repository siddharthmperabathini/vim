-- lua/plugins/mason.lua
return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    },
    opts = function(_, opts)
        return opts
    end,
    config = function(_, opts)
        require("mason").setup(opts)
        require("mason-lspconfig").setup({
            ensure_installed = { "pyright", "clangd", "lua_ls" },
            -- DO NOT use 'handlers' here.
            -- Let your lsp-plugins.lua handle the setup instead.
        })
    end,
}

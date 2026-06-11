return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup({
            options = {
                -- Use lowercase "catppuccin"
                theme = "auto",
            },
        })
    end,
}

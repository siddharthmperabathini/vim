-- Telescope (for searching)
return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = function(_, opts)
            opts.defaults = opts.defaults or {}
            opts.defaults.preview = opts.defaults.preview or {}
            opts.defaults.preview.treesitter = false
            return opts
        end,
    },
    -- Use Telescope for selection menus
    {
        "nvim-telescope/telescope-ui-select.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            require("telescope").load_extension("ui-select")
        end,
    },
}

return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },  -- Adds file icons
    lazy = true,  -- Don't load immediately unless triggered
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },  -- Optional lazy-load triggers
    keys = {
        {
            "<leader>tr",  -- Your keybind
            function()
                require("nvim-tree.api").tree.toggle()
            end,
            desc = "Toggle NvimTree"
        },
    },
    opts = function(_, opts)
        opts.view = opts.view or {}
        opts.view.width = 30
        opts.view.side = "left"
        
        opts.update_focused_file = opts.update_focused_file or {}
        opts.update_focused_file.enable = true
        opts.update_focused_file.update_cwd = true
        
        opts.git = opts.git or {}
        opts.git.enable = true
        
        opts.renderer = opts.renderer or {}
        opts.renderer.icons = opts.renderer.icons or {}
        opts.renderer.icons.show = { file = true, folder = true, git = true }
        
        return opts
    end,
    config = function(_, opts)
        require("nvim-tree").setup(opts)
        -- Optional: Auto-open file explorer on startup
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                require("nvim-tree.api").tree.open()
            end,
        })
    end
}


-- List of parsers to install
local ensure_installed_parsers = {
    "lua",
    "javascript",
    "python",
    "c",
    "vim",
    "vimdoc",
    "html",
    "css",
    "make",
    "bash",
}
return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        local parsers = {
            "lua",
            "javascript",
            "python",
            "c",
            "vim",
            "vimdoc",
            "html",
            "css",
            "make",
            "bash",
        }
        for _, parser in ipairs(parsers) do
            if not vim.tbl_contains(opts.ensure_installed, parser) then
                table.insert(opts.ensure_installed, parser)
            end
        end
        opts.auto_install = true
        opts.highlight = opts.highlight or {}
        opts.highlight.enable = true
        opts.indent = opts.indent or {}
        opts.indent.enable = true
        return opts
    end,
}

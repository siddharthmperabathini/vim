return {
    "kawre/leetcode.nvim",
    build = ":MasonInstall html-lsp css-lsp typescript-language-server",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    opts = {
        lang = "python", -- default language, change to "cpp", "javascript", etc.
        cookies = {
            csrftoken = "your_csrftoken_here",
            LEETCODE_SESSION = "your_session_here",
        },
    },
}

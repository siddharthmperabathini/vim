return {
    "gelguy/wilder.nvim",
    dependencies = { "romgrk/fzy-lua-native" },
    event = "CmdlineEnter",
    config = function()
        local wilder = require("wilder")

        wilder.setup({ modes = { ":", "/", "?" } })

        -- Fuzzy matching for better autocomplete
        wilder.set_option("pipeline", {
            wilder.branch(
                wilder.cmdline_pipeline({
                    fuzzy = 1,
                    fuzzy_filter = wilder.lua_fzy_filter(),
                }),
                wilder.vim_search_pipeline()
            ),
        })

        -- Popup menu renderer with highlights
        wilder.set_option(
            "renderer",
            wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
                border = "rounded",
                highlights = {
                    border = "Normal",
                    accent = wilder.make_hl("WilderAccent", "Pmenu", {
                        { a = 1 },
                        { a = 1 },
                        { foreground = "#f4468f" },
                    }),
                },
                pumblend = 10, -- slight transparency
                min_width = "30%",
                max_width = "60%",
                max_height = "25%",
                highlighter = wilder.lua_fzy_highlighter(),
                left = { " ", wilder.popupmenu_devicons() }, -- file icons (requires nvim-web-devicons)
                right = { " ", wilder.popupmenu_scrollbar() },
            }))
        )
    end,
}

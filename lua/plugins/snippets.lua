return {
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        build = "make install_jsregexp",

        config = function()
            local luasnip = require("luasnip")

            -- carica snippet vscode-style (friendly-snippets)
            require("luasnip.loaders.from_vscode").lazy_load()

            -- opzionale: snippet custom LaTeX
            require("luasnip.loaders.from_lua").load({
                paths = "~/.config/nvim/lua/snippets",
            })
        end,
    },
}

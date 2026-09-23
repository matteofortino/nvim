return {
    {
        "echasnovski/mini.snippets",
        version = "*",
        dependencies = {
            -- Snippet collection covering JS/TS, Python, Go, Rust, C++, Lua, HTML, etc.
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local mini_snippets = require("mini.snippets")
            local gen_loader = mini_snippets.gen_loader

            -- Load both the latex-friendly snippet packs and the custom
            -- `snippets/tex.json` file for `tex`, `latex` and `plaintex` buffers
            -- (language detected is `latex` with the treesitter parser installed)
            local latex_patterns = {
                "latex/**/*.json",
                "**/latex.json",
                "tex/**/*.json",
                "**/tex.json",
                "mtex/**/*.json",
                "**/mtex.json",
            }

            mini_snippets.setup({
                snippets = {
                    -- Automatically loads language snippets from runtime paths (friendly-snippets)
                    gen_loader.from_lang({
                        lang_patterns = {
                            latex = latex_patterns,
                            tex = latex_patterns,
                            plaintex = latex_patterns,
                        },
                    }),
                },
                mappings = {
                    expand = "<C-j>", -- Expand snippet at cursor
                    jump_next = "<C-l>", -- Jump to next snippet field
                    jump_prev = "<C-h>", -- Jump to previous snippet field
                    stop = "<C-c>", -- Stop snippet session
                },
            })
        end,
    },
}

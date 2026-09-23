return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        preset = "obsidian",
        heading = {
            position = "inline",
            sign = false,

            icons = function(ctx)
                local numbers = {}

                for i = 1, ctx.level do
                    local n = ctx.sections[i]

                    if n and n > 0 then
                        table.insert(numbers, tostring(n))
                    end
                end

                return table.concat(numbers, ".") .. " "
            end,
        },
    },
}

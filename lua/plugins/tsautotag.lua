return {
    "windwp/nvim-ts-autotag",
    event = { "InsertEnter", "BufReadPre", "BufNewFile" },
    config = function()
        require("nvim-ts-autotag").setup({
            opts = {
                enable_close = true,  -- auto close tags
                enable_rename = true, -- auto rename paired tags
                enable_close_on_slash = false,
            },
            per_filetype = {
                ["html"] = true,
                ["javascript"] = true,
                ["typescript"] = true,
                ["javascriptreact"] = true,
                ["typescriptreact"] = true,
                ["svelte"] = true,
                ["vue"] = true,
            },
        })
    end,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
}

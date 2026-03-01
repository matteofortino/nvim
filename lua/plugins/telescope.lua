return {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
        vim.keymap.set("n", "<leader>ff", ":Telescope fd<CR>", { desc = "Find Files" })
        vim.keymap.set("n", "<leader>fg", ":Telescope grep_string<CR>", { desc = "Grep strings" })
        vim.keymap.set("n", "<leader>fs", ":Telescope lsp_document_symbols<CR>", { desc = "Lsp symbols" })
    end
}

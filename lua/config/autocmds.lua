-- highlight_yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
    pattern = "*",
    desc = "highlight selection on yank",
    callback = function()
        vim.highlight.on_yank({ timeout = 200, visual = true })
    end,
})

-- latex document compilation
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.tex",
    callback = function()
        local file = vim.fn.expand("%:p")
        local dir = vim.fn.expand("%:p:h")

        vim.fn.jobstart({ "latexmk", "-pdf", file }, {
            cwd = dir,
            stdout_buffered = true,
            stderr_buffered = true,
        })
    end,
})

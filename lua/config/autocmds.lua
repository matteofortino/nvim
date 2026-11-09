-- highlight_yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern = "*",
	desc = "highlight selection on yank",
	callback = function()
		vim.highlight.on_yank({ timeout = 200, visual = true })
	end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.tex",
	callback = function(event)
		local path = vim.fn.fnamemodify(event.file, ":p")
		local dir = vim.fn.fnamemodify(path, ":h")
		local name = vim.fn.fnamemodify(path, ":t")

		vim.fn.jobstart({
			"latexmk",
			"-pdf",
			"-interaction=nonstopmode",
			"-synctex=1",
			"-file-line-error",
			name,
		}, { cwd = dir })
	end,
})

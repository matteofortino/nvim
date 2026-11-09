vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.clipboard = "unnamedplus"

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.colorcolumn = "80"

vim.opt.complete:append("o")
vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.o.pumheight = 20

vim.opt.conceallevel = 0

-- Don't create swap files or show swap-file recovery prompts.
vim.opt.swapfile = false

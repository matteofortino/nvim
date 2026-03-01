vim.g.mapleader = " " 
vim.keymap.set("i", "jk", "<Esc>", { desc = "Go to normal mode" })
vim.keymap.set("n", "<C-n>", ":Oil<CR>", { desc = "Open file explorer" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<leader>p", ":Bufferin<CR>")


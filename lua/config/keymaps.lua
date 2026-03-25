vim.g.mapleader = " "
vim.keymap.set("i", "jk", "<Esc>", { desc = "Go to normal mode" })
vim.keymap.set("n", "<C-n>", ":Oil<CR>", { desc = "Open file explorer" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<leader>p", ":Bufferin<CR>")
vim.keymap.set("i", ";;a", "à")
vim.keymap.set("i", ";;e", "è")
vim.keymap.set("i", ";;i", "ì")
vim.keymap.set("i", ";;o", "ò")
vim.keymap.set("i", ";;u", "ù")

vim.keymap.set("i", ";;A", "À")
vim.keymap.set("i", ";;E", "È")
vim.keymap.set("i", ";;I", "Ì")
vim.keymap.set("i", ";;O", "Ò")
vim.keymap.set("i", ";;U", "Ù")

return {
    "williamboman/mason.nvim",
    dependencies = {
        -- We keep mason-lspconfig strictly to auto-install your tools
        -- and auto-enable them in the new 0.12 native API.
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        -- =====================================================================
        -- 1. MASON BINARY MANAGEMENT
        -- =====================================================================
        require("mason").setup()

        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls", "clangd", "zls", "tailwindcss" },
            -- In Neovim 0.12+, mason-lspconfig can automatically run
            -- vim.lsp.enable() for your installed servers.
            automatic_enable = true,
        })

        -- =====================================================================
        -- 2. NATIVE LSP CONFIGURATIONS (No nvim-lspconfig needed)
        -- =====================================================================
        -- Mason put the binaries in your PATH, so native Neovim can launch them.
        -- We just need to tell Neovim how to configure and attach them.

        vim.lsp.config("clangd", {
            root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
        })

        vim.lsp.config("zls", {
            root_markers = { "build.zig", "zls.json", ".git" },
            settings = {
                zls = { enable_inlay_hints = true, enable_snippets = true, warn_style = true }
            }
        })

        vim.lsp.config("lua_ls", {
            root_markers = { ".luarc.json", ".git" },
            settings = {
                Lua = {
                    runtime = { version = "LuaJIT" },
                    diagnostics = { globals = { "vim" } },
                    workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
                    format = { enable = true, defaultConfig = { indent_style = "space", indent_size = "2" } },
                }
            }
        })

        vim.lsp.config("tailwindcss", {
            root_markers = { "tailwind.config.js", "tailwind.config.ts", ".git" },
            filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "heex" }
        })

        -- =====================================================================
        -- 3. INLINE DIAGNOSTICS
        -- =====================================================================
        vim.diagnostic.config({
            virtual_text = { prefix = "●", spacing = 2 },
            signs = true,
            underline = true,
            update_in_insert = true, -- Real-time errors as you type
            severity_sort = true,
        })

        -- =====================================================================
        -- 4. NATIVE AUTO-COMPLETION
        -- =====================================================================
        vim.opt.completeopt = { "menu", "menuone", "noselect" }

        -- Trigger completion natively on every valid keystroke
        vim.api.nvim_create_autocmd("InsertCharPre", {
            callback = function()
                if vim.fn.pumvisible() == 0 and vim.v.char:match("[%w%.%:%/%-]") then
                    vim.schedule(function()
                        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true), "n")
                    end)
                end
            end,
        })

        -- Map Tab and Enter to navigate the native popup menu
        vim.keymap.set("i", "<Tab>", function() return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>" end,
            { expr = true })
        vim.keymap.set("i", "<S-Tab>", function() return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>" end,
            { expr = true })
        vim.keymap.set("i", "<CR>", function() return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>" end, { expr = true })

        -- =====================================================================
        -- 5. KEYMAPS & FORMAT-ON-SAVE
        -- =====================================================================
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local bufnr = args.buf
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                local opts = { noremap = true, silent = true, buffer = bufnr }

                -- Essential keymaps
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

                -- Native format on save
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = bufnr, id = client.id })
                        end,
                    })
                end
            end,
        })
    end
}

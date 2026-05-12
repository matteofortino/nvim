return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig", -- We need this back for the default server configurations!
    },
    config = function()
        -- =====================================================================
        -- 1. MASON & AUTOMATIC LSP ROUTING
        -- =====================================================================
        require("mason").setup()

        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls", "clangd" }, -- Add servers you always want here

            -- This is the magic block. It automatically takes ANY server you install
            -- in Mason and sets it up using the correct default commands/filetypes.
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup({})
                end,

                -- You can still override specific servers if you want custom settings
                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup({
                        settings = {
                            Lua = {
                                diagnostics = { globals = { "vim" } },
                                format = { enable = true, defaultConfig = { indent_style = "space", indent_size = "4" } },
                            }
                        }
                    })
                end,
            }
        })

        -- =====================================================================
        -- 2. INLINE DIAGNOSTICS (Native 0.12)
        -- =====================================================================
        vim.diagnostic.config({
            virtual_text = { prefix = "●", spacing = 2 },
            signs = true,
            underline = true,
            update_in_insert = true, -- Real-time errors as you type
            severity_sort = true,
        })

        -- =====================================================================
        -- 3. NATIVE AUTO-COMPLETION (Native 0.12)
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
        -- 4. KEYMAPS & FORMAT-ON-SAVE (Native 0.12)
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
                if client and client:supports_method("textDocument/formatting") then
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

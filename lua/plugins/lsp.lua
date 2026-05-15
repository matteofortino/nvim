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
            --update_in_insert = true, -- Real-time errors as you type
            severity_sort = true,
        })

        -- =====================================================================
        -- 3. NATIVE AUTO-COMPLETION (Native 0.12)
        -- =====================================================================
        vim.opt.completeopt = { "menu", "menuone", "noselect" }

        -- Trigger completion natively on every valid keystroke
        vim.api.nvim_create_autocmd("InsertCharPre", {
            callback = function()
                -- Check 1: Is the popup menu already visible?
                -- Check 2: Does the character match our trigger pattern?
                -- Check 3: Does the buffer have an omnifunc set? (This prevents the Oil.nvim error)
                if vim.fn.pumvisible() == 0
                    and vim.v.char:match("[%w%.%:%/%-]")
                    and vim.bo.omnifunc ~= "" then
                    vim.schedule(function()
                        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true), "n")
                    end)
                end
            end,
        })

        -- Map Tab and Enter to navigate the native popup menu
        -- Upgraded Tab: Menu navigation OR Snippet jumping
        vim.keymap.set({ "i", "s" }, "<Tab>", function()
            if vim.fn.pumvisible() == 1 then
                return "<C-n>"                            -- Go down the menu
            elseif vim.snippet.active({ direction = 1 }) then
                return "<cmd>lua vim.snippet.jump(1)<CR>" -- Jump forward in snippet
            else
                return "<Tab>"                            -- Regular tab
            end
        end, { expr = true, silent = true })

        -- Upgraded Shift-Tab: Menu navigation OR Snippet jumping
        vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
            if vim.fn.pumvisible() == 1 then
                return "<C-p>"                             -- Go up the menu
            elseif vim.snippet.active({ direction = -1 }) then
                return "<cmd>lua vim.snippet.jump(-1)<CR>" -- Jump backward in snippet
            else
                return "<S-Tab>"
            end
        end, { expr = true, silent = true })

        -- (Keep your Enter keymap exactly as we set it earlier)
        vim.keymap.set("i", "<S-CR>", function() return vim.fn.pumvisible() == 1 and "<C-y>" or "<S-CR>" end,
            { expr = true })

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

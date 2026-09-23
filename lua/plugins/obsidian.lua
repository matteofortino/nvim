return {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    dependencies = {
        "folke/snacks.nvim",
    },
    opts = {
        legacy_commands = false,
        workspaces = {
            {
                name = "personal",
                path = "~/Vaults/Matteo's Vault/",
            },
        },
    },
}

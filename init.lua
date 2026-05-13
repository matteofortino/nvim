require("vim._core.ui2").enable({
    enable = true,
    msg = {
        target = "cmd",
        pager = { height = 0.5 },
        dialog = { height = 0.5 },
        cmd = { height = 0.5 },
        msg = { height = 0.5, timeout = 45000 },
    },
})
require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")

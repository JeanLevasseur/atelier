vim.opt_local.foldmethod = 'expr'
vim.opt_local.foldexpr = "v:lua.require('folds.lua').foldexpr()"
vim.opt_local.foldlevel = 0

vim.keymap.set(
    'n',
    'zo',
    function()
        require('folds.lua').open()
    end, { buffer = true }
)

vim.keymap.set(
    'n',
    'zc',
    function()
        require('folds.lua').close()
    end, { buffer = true }
)

vim.keymap.set(
    'n',
    'za',
    function()
        require('folds.lua').toggle()
    end, { buffer = true }
)

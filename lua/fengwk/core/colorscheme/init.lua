local configurator = require("fengwk.core.colorscheme.configurator")

vim.api.nvim_create_augroup("user_theme", { clear = true })
vim.api.nvim_create_autocmd(
  { "ColorScheme" },
  { group = "user_theme", pattern = "*", callback = function()
    configurator.on_change(vim.fn.expand("<amatch>"))
  end}
)

configurator.setup()
-- 修改lualine的nightfly主题
local nightfly = vim.tbl_deep_extend("force", require("lualine.themes.nightfly"), {
  normal = {
    a = {
      bg = "#56D1FF",
    },
  },
  insert = {
    a = {
      bg = "#3EFFDC",
    },
  },
  visual = {
    a = {
      bg = "#FF61EF",
    },
  },
  command = {
    a = {
      bg = "#FFDA7B",
      fg = "#000000",
      gui = "bold",
    },
  },
})

return {
  setup = function()
    require("fengwk.plugins.lualine").setup({
      options = {
        theme = nightfly
      }
    })
  end
}
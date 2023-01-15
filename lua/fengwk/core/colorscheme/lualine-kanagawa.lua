local auto = vim.tbl_deep_extend("force", require("lualine.themes.auto"), {
  normal = {
    a = {
      gui = "bold"
    }
  },
  insert = {
    a = {
      gui = "bold"
    }
  },
  replace = {
    a = {
      gui = "bold"
    }
  },
  visual = {
    a = {
      gui = "bold"
    }
  },
  command = {
    a = {
      gui = "bold"
    }
  },
})

return {
  setup = function()
    require("fengwk.plugins.lualine").setup({
      options = {
        theme = auto
      }
    })
  end
}
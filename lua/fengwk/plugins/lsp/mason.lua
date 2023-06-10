-- https://github.com/williamboman/mason.nvim
local mason_status, mason = pcall(require, "mason")
if not mason_status then
  return
end

mason.setup({
  ui = {
    border = "rounded",
  }
})

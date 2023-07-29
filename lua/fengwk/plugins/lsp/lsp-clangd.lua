-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#clangd

return {
  cmd = { "clangd", "--offset-encoding=utf-16" }, -- 解决clangd和copilot的offset-encoding不同导致的冲突，see https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
}

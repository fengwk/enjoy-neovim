local lsp = {}

-- local function any_lsp_client_support(method)
--   local bufnr = vim.api.nvim_get_current_buf()
--   local supported = false
--   vim.lsp.for_each_buffer_client(bufnr, function(client)
--     if client.supports_method(method) then
--       supported = true
--     end
--   end)
--   return supported
-- end

return lsp

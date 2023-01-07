local M = {}

M.debug = function()
  vim.ui.input({ prompt = "MainClass: " }, function(main_class)
    require 'dap'.run({
      type = 'java',
      request = 'launch',
      name = 'Launch Main Class',
      mainClass = main_class,
    })
  end)
end

local function remote_debug(host, port)
  require 'dap'.run({
    type = 'java',
    request = 'attach',
    name = 'Debug (Attach) - Remote',
    hostName = host,
    port = port,
  })
end

M.remote_debug_by_input = function()
  vim.ui.input({ prompt = "Host: " }, function(host)
    vim.ui.input({ prompt = "Port: " }, function(port)
      remote_debug(host, port)
    end)
  end)
end

M.test = function()
  vim.lsp.buf_request(0, "textDocument/codeLens", vim.lsp.util.make_position_params(), function(err, result, ctx, config)
      print(vim.inspect(err))
      print(vim.inspect(result))
      print(vim.inspect(ctx))
      print(vim.inspect(config))
  end)

  -- vim.lsp.buf_request(
  --   0,
  --   "textDocument/documentSymbol",
  --   {
  --     textDocument = {
  --       uri = vim.uri_from_bufnr(0)
  --     },
  --   },
  --   function(err, result, ctx, config)
  --     vim.notify(vim.inspect(result))
  --     -- print(vim.inspect(err))
  --     -- print(vim.inspect(result))
  --     -- print(vim.inspect(ctx))
  --     -- print(vim.inspect(config))
  --   end
  -- )
end

-- M.generate_set = function()
--
--   vim.lsp.buf_request(0, "textDocument/typeDefinition", vim.lsp.util.make_position_params(), function(err, result, ctx, config)
--       print(vim.inspect(err))
--       print(vim.inspect(result))
--       print(vim.inspect(ctx))
--       print(vim.inspect(config))
--   end)
--
--   vim.lsp.buf_request(
--     0,
--     "textDocument/documentSymbol",
--     {
--       textDocument = {
--         uri = vim.uri_from_bufnr(0)
--       },
--     },
--     function(err, result, ctx, config)
--       vim.notify(vim.inspect(result))
--       -- print(vim.inspect(err))
--       -- print(vim.inspect(result))
--       -- print(vim.inspect(ctx))
--       -- print(vim.inspect(config))
--     end
--   )
-- end

return M
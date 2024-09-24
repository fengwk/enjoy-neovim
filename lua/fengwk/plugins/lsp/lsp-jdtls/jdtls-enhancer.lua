local utils = require("fengwk.utils")

-- 这个函数提供调试功能
local function debug()
  vim.ui.input({ prompt = "MainClass: " }, function(main_class)
    require("dap").run({
      type = "java",
      request = "launch",
      name = "Launch Main Class",
      mainClass = main_class,
    })
  end)
end

-- 这个函数提供远程调试功能
local function do_remote_debug(host, port)
  if host and port then
    require("dap").run({
      type = "java",
      request = "attach",
      name = "Debug (Attach) - Remote",
      hostName = host,
      port = port,
    })
    vim.notify("\rattach to " .. host .. ":" .. port)
  end
end

-- 通过输入参数提供远程调试能力
local function remote_debug()
  vim.ui.input({ prompt = "Host [127.0.0.1]: " }, function(host)
    if not host or #host == 0 then
      host = "127.0.0.1"
    end
    vim.ui.input({ prompt = "Port [10000]: " }, function(port)
      if not port or #port == 0 then
        port = "10000"
      end
      do_remote_debug(host, port)
    end)
  end)
end

-- 复制引用
local function copy_reference()
  local bufnr = vim.api.nvim_get_current_buf()
  local candidates = vim.lsp.get_active_clients({ name = "jdtls", bufnr = bufnr })
  if not candidates or #candidates == 0 then
    print("lsp client not found")
    return
  end
  local client = candidates[1]
  client.request("textDocument/hover", vim.lsp.util.make_position_params(), function(_, res, _, _)
    if res and res.contents then
      local sign = #res.contents > 1 and res.contents[1].value or res.contents.value
      vim.fn.setreg('+', sign)
      vim.fn.setreg('"', sign)
    else
      print("reference not found")
    end
  end)
end

local function jump_to_location(uri)
  if not uri then
    return
  end

  if not utils.fs.is_uri(uri) then
    uri = vim.uri_from_fname(uri)
  end

  local pos = {
    character = 0,
    line = 0
  }

  vim.lsp.util.jump_to_location({
    uri = uri,
    range = {
      start = pos,
      ['end'] = pos,
    },
  }, "utf-16")
end

return {
  debug            = debug,
  remote_debug     = remote_debug,
  copy_reference   = copy_reference,
  jump_to_location = jump_to_location,
}

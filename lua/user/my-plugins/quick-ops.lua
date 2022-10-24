-- 这个模块里提供一些常用的操作集合及注册方式
local M = {}

-- 通用的操作
local common_ops = {}
-- 文件类型特定的操作
local ft_ops = {}

-- 注册一个操作
-- @param op_item 操作项
-- @param ft 特定文件类型，如果需要在所有文件类型中使用则无需使用该参数
M.register_op = function(op_item, ft)
  if ft then
    ft_ops[ft] = ft_ops[ft] or {}
    table.insert(ft_ops[ft], op_item)
  else
    common_ops[ft] = common_ops[ft] or {}
    table.insert(common_ops[ft], op_item)
  end
end

-- 注册内建操作

-- 格式化lua的require语句
M.register_op({ name = "Format Require", type = "EX", cmd = [[%s#\vrequire[^"']*["']([^"']+)["'][)]{0,1}#require("\1")#g]] }, "lua")

-- 设置QuickCommand提示窗快捷键
vim.keymap.set("n", "<leader>p", function ()
  local op1 = common_ops
  local op2 = {}
  if vim.bo.filetype then
    op2 = ft_ops[vim.bo.filetype] or {}
  end
  local ops = vim.tbl_deep_extend("force", op1, op2)
  vim.ui.select(ops, {
    prompt = "Quick Ops",
    format_item = function(item)
      return item.name
    end
  }, function(op)
    if op.type == "EX" then
      vim.api.nvim_command(op.cmd)
    end
  end)
end, { noremap = true, silent = true, desc = "Quick Ops" })

return M
-- windows依赖于：https://github.com/fengwk/im-switch-for-windows
local utils = require("fengwk.utils")

-- 缓存文件路径
local state_filename = utils.fs.stdpath("cache", "im-switch/state")

local state_out = nil;
local state_cache_timeout = 1e6 * 100 -- 100毫秒，配置读取超时
local fcitx5_state_cache = nil
local fcitx5_state_cache_pre_read = 0

local function read_fcitx5_state()
  local cur_nanos = vim.loop.hrtime()
  if cur_nanos < fcitx5_state_cache_pre_read + state_cache_timeout and fcitx5_state_cache then
    return fcitx5_state_cache
  end
  fcitx5_state_cache = utils.sys.system { "fcitx5-remote" }
  if type(fcitx5_state_cache) == "string" then
    fcitx5_state_cache = vim.trim(fcitx5_state_cache)
  end
  fcitx5_state_cache_pre_read = cur_nanos
  return fcitx5_state_cache
end

-- 自动切换fcitx5输入法
-- @param mode in表示进入其它模式 out表示进入normal模式
local function auto_switch_fcitx5(mode)
  if mode == "in" then -- 进入插入模式
    if state_out == "2" then -- 2说明退出前是active的，应该被重置
      utils.sys.system { "fcitx5-remote", "-o" }
    end
  else
    local state = read_fcitx5_state()
    state_out = state
    if state ~= "1" then
      utils.sys.system { "fcitx5-remote", "-c" }
    end
  end
end

-- 自动切换微软拼音输入法
local function auto_switch_micro_pinyin(mode)
  if mode == "in" then -- 进入插入模式
    local state = utils.fs.read_file(state_filename)
    if state == "zh" then -- zh说明退出前是中文的，应该被重置
      utils.sys.system { "im-switch-x64.exe", "zh" }
    end
  else
    -- 退出插入模式时将将当前状态记录下来，并切回英文
    utils.fs.ensure_dir(vim.fn.fnamemodify(state_filename, ":h"))
    local state = utils.sys.system { "im-switch-x64.exe", "en" }
    utils.fs.write_file(state_filename, state)
  end
end

-- wsl版本，使用cmd.exe会对性能有一定的影响
-- cmd.exe参考：https://www.cnblogs.com/baby123/p/11459316.html
local function auto_switch_micro_pinyin_wsl(mode)
  if mode == "in" then -- 进入插入模式
    local state = utils.fs.read_file(state_filename)
    if state == "zh" then -- zh说明退出前是中文的，应该被重置
      utils.sys.system { "cmd.exe", "/C",  "im-switch-x64.exe", "zh"}
    end
  else
    -- 退出插入模式时将将当前状态记录下来，并切回英文
    utils.fs.ensure_dir(vim.fn.fnamemodify(state_filename, ":h"))
    local state = utils.sys.system { "cmd.exe", "/C", "im-switch-x64.exe", "en" }
    utils.fs.write_file(state_filename, state)
  end
end

-- 自动切换输入法
local function auto_switch_im(mode)
  if utils.sys.os == "win" then
    return auto_switch_micro_pinyin(mode)
  else
    if utils.sys.os == "wsl" then
      return auto_switch_micro_pinyin_wsl(mode)
    else
      return auto_switch_fcitx5(mode)
    end
  end
end

local function in_auto_switch_im()
    local ft = vim.bo.filetype
    if ft == "markdown" then
      auto_switch_im("in")
    end
end

local function out_auto_switch_im()
    auto_switch_im("out")
end

-- 在相应的时机自动进行函数调用
-- vim自动命令参考：http://yyq123.github.io/learn-vim/learn-vi-49-01-autocmd.html
-- 查看当前文档类型
-- :echo &filetype
-- :help api-autocmd
vim.api.nvim_create_augroup("user_im_switch", { clear = true })
vim.api.nvim_create_autocmd(
  { "InsertEnter" },
  -- 仅对指定类型的文件进行中文重置
  { group = "user_im_switch", pattern = "*", callback = in_auto_switch_im }
)
-- 进入select模式的自动命令
vim.api.nvim_create_autocmd(
  { "ModeChanged" },
  { group = "user_im_switch", pattern = "*:[sS]*", callback = in_auto_switch_im }
)
-- 进入normal模式自动退出
vim.api.nvim_create_autocmd(
  { "ModeChanged" },
  { group = "user_im_switch", pattern = "*:n", callback = out_auto_switch_im }
)

-- windows切换输入法成本较高，降低切换频率
if utils.sys.os ~= "win" then
  vim.api.nvim_create_autocmd(
    { "BufCreate" },
    { group = "user_im_switch", pattern = "*", callback = out_auto_switch_im }
  )
  vim.api.nvim_create_autocmd(
    { "BufEnter" },
    { group = "user_im_switch", pattern = "*", callback = out_auto_switch_im }
  )
  vim.api.nvim_create_autocmd(
    { "BufLeave" },
    { group = "user_im_switch", pattern = "*", callback = out_auto_switch_im }
  )
end

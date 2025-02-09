-- https://github.com/windwp/nvim-ts-autotag
local ok, nvim_ts_autotag = pcall(require, "nvim-ts-autotag")
if not ok then
  return
end

nvim_ts_autotag.setup({
  opts = {
    -- Defaults
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
    enable_close_on_slash = false -- Auto close on trailing </
  },
})

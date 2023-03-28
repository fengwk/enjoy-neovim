local ok, stickybuf = pcall(require, "stickybuf")
if not ok then
  vim.notify("stickybuf can not be required.")
  return
end

stickybuf.setup()
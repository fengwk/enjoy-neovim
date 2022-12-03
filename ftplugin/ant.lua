local ok, jdtls_setup = pcall(require, "fengwk.plugins.lsp.lsp-jdtls.jdtls-setup")
if not ok then
  return
end

jdtls_setup.setup()
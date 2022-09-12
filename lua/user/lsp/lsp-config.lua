-- 每个元素是一个lsp配置对象，包含2项属性：
-- setup function     完成当前lsp的安装
-- lsp   string|array 包含所需的所有lsp服务器
return {
  require("user/lsp/lsp-bash"),
  require("user/lsp/lsp-c"),
  require("user/lsp/lsp-css"),
  require("user/lsp/lsp-go"),
  require("user/lsp/lsp-groovy"),
  require("user/lsp/lsp-html"),
  require("user/lsp/lsp-java"),
  require("user/lsp/lsp-json"),
  require("user/lsp/lsp-lua"),
  require("user/lsp/lsp-powershell"),
  require("user/lsp/lsp-python"),
  require("user/lsp/lsp-sql"),
  require("user/lsp/lsp-ts"),
  require("user/lsp/lsp-vim"),
  require("user/lsp/lsp-yaml"),
}
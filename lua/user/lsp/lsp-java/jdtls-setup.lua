-- 每个java缓冲区需要执行setup函数，首次执行将启动lsp并attach，后续仅attach

local jdtls = require "jdtls"
local utils = require "user.utils"
local lsp_common = require "user.lsp.lsp-common"

local stdpath_config = vim.fn.stdpath("config")
local stdpath_data = vim.fn.stdpath("data")
local stdpath_cache = vim.fn.stdpath("cache")

local M = {}

M.setup = function()

  -- 不同环境使用不同脚本
  local jdtls_cmd = utils.fs_concat { stdpath_config, "lua", "user", "lsp", "lsp-java", "jdtls-runner" .. (utils.os_name == "win" and ".bat" or ".sh") }

  -- 获取工作目录
  local workspace_dir = utils.find_root_dir({ "mvnw", "gradlew", "pom.xml" }) or vim.fn.getcwd()
  -- 获取工作目录名称
  local workspace_name = vim.fn.fnamemodify(workspace_dir, ":p:h:t")

  -- 配置
  local config = {}

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  config.on_attach = function(client, bufnr)
    lsp_common.on_attach(client, bufnr)
    -- jdtls特性
    jdtls.setup_dap({ hotcodereplace = "auto" })
    jdtls.setup.add_commands()

    -- 注册调试命令
    vim.cmd([[
      command! JdtTestClass lua require'jdtls'.test_class()
      command! JdtTestMethod lua require'jdtls'.test_nearest_method()
    ]])

  end

  config.capabilities = lsp_common.make_capabilities()

  config.cmd = {
    jdtls_cmd,
    stdpath_data,
    stdpath_cache,
    workspace_name,
  }

  config.root_dir = workspace_dir

  config.settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*"
        }
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      configuration = {
        -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
        -- And search for `interface RuntimeOption`
        -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
        runtimes = {
          {
            name = "JavaSE-1.8",
            path = "/usr/lib/jvm/java-8-openjdk",
            sources = "/usr/lib/jvm/java-8-openjdk/src.zip",
            javadoc = "https://docs.oracle.com/javase/8/docs/api/",
            default = true,
          },
          {
            name = "JavaSE-11",
            path = "/usr/lib/jvm/java-11-openjdk",
            sources = "/usr/lib/jvm/java-11-openjdk/lib/src.zip",
            javadoc = "https://docs.oracle.com/javase/11/docs/api/",
          },
          {
            name = "JavaSE-17",
            path = "/usr/lib/jvm/java-17-openjdk",
            sources = "/usr/lib/jvm/java-17-openjdk/lib/src.zip",
            javadoc = "https://docs.oracle.com/javase/17/docs/api/",
          },
        },
      },
    },
  }

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don"t plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  local bundles = {
      vim.fn.glob(utils.fs_concat({ stdpath_config, "lua", "user", "lsp", "lsp-java", "jdtls-plugins", "java-debug", "com.microsoft.java.debug.plugin-*.jar" })),
  }
  vim.list_extend(bundles, vim.split(vim.fn.glob(utils.fs_concat({ stdpath_config, "lua", "user", "lsp", "lsp-java", "jdtls-plugins", "vscode-java-test", "*.jar" })), "\n"))

  local extendedClientCapabilities = jdtls.extendedClientCapabilities
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
  config.init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
  }

  -- This starts a new client & server,
  -- or attaches to an existing client & server depending on the `root_dir`.
  require("jdtls").start_or_attach(config)

end

return M
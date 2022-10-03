-- 每个java缓冲区需要执行setup函数，首次执行将启动lsp并attach，后续仅attach

local jdtls = require "jdtls"
local utils = require "user.utils"
local lsp_utils = require "user.ide.lsp-utils"

local stdpath_config = vim.fn.stdpath("config")
local stdpath_data = vim.fn.stdpath("data")
local stdpath_cache = vim.fn.stdpath("cache")

local java_home = os.getenv("JAVA_HOME_17")
local cp_sp = utils.os_name == "win" and ";" or ":"
local cp = "." .. cp_sp .. java_home .. "/lib/dt.jar" .. cp_sp .. java_home .. "/lib/tools.jar"

local java = java_home .. "/bin/java"
local jdtls_home = stdpath_data .. "/mason/packages/jdtls"
local lombok_jar = jdtls_home .. "/lombok.jar"
local launcher_jar = vim.fn.glob(jdtls_home .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local config_dir = jdtls_home .. (utils.os_name == "win" and "/config_win" or "/config_linux")

local M = {}

M.setup = function()

  -- 获取工作目录
  local workspace_dir = utils.find_root_dir({
    'build.xml', -- Ant
    "mvnw", -- Maven
    'pom.xml', -- Maven
    'settings.gradle', -- Gradle
    'settings.gradle.kts', -- Gradle
    "gradlew", -- Gradle
  }) or vim.fn.getcwd()
  -- 转义工作目录作为名称
  local workspace_name = string.gsub(workspace_dir, "/", "__")
  -- 数据目录
  local data_dir = stdpath_cache .. "/lsp/jdtls/" .. workspace_name

  -- jdtls配置
  local config = {}

  -- jdtls启动命令
  config.cmd = {
    java,
    "-cp", cp,
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx2G",
    "-javaagent:" .. lombok_jar,
    "-jar", launcher_jar,
    "-configuration", config_dir,
    "-data", data_dir,
    "--add-modules=ALL-SYSTEM",
    "--add-opens java.base/java.util=ALL-UNNAMED",
    "--add-opens java.base/java.lang=ALL-UNNAMED",
  }

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  config.on_attach = function(client, bufnr)
    lsp_utils.on_attach(client, bufnr)
    -- jdtls特性
    jdtls.setup_dap({ hotcodereplace = "auto" })
    jdtls.setup.add_commands()

    -- https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration
    -- 注册用于调试的主类，如果是新增的main方法需要使用:JdtRefreshDebugConfigs命令刷新
    require("jdtls.dap").setup_dap_main_class_configs()
    -- 运行当前类的main方法
    -- vim.keymap.set("n", "<leader>dd", "<Cmd>lua require('dap').run({type='java',request='launch'})<CR>", { noremap = true, silent = true, desc = "Dap Continue" })

    -- local dap = require('dap')
    -- dap.configurations.java = {
    --   {
    --     type = 'java';
    --     request = 'attach';
    --     name = "Debug (Attach) - Remote";
    --     hostName = "127.0.0.1";
    --     port = 5005;
    --   },
    -- }
    -- 注册调试命令
    vim.cmd([[
      command! JdtTestClass lua require'jdtls'.test_class()
      command! JdtTestMethod lua require'jdtls'.test_nearest_method()
      command! JdtRemoteDebug lua require'user.ide.jdtls.command'.remote_debug_by_input()
    ]])

  end

  config.capabilities = lsp_utils.make_capabilities()

  config.root_dir = workspace_dir

  config.settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      completion = {
        -- 这些包使用静态成员
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
        -- 不在import中使用*
        organizeImports = {
          starThreshold = 999,
          staticStarThreshold = 999,
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

  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  -- debug插件
  local bundles = {
      vim.fn.glob(stdpath_config .. "/lua/user/ide/jdtls/plugins/java-debug/com.microsoft.java.debug.plugin-*.jar"),
  }
  -- 单元测试插件
  vim.list_extend(bundles, vim.split(vim.fn.glob(stdpath_config .. "/lua/user/ide/jdtls/plugins/vscode-java-test/*.jar" ), "\n"))

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
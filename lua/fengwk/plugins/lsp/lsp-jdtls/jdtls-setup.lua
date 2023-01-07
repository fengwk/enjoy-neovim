-- 每个java缓冲区需要执行setup函数，首次执行将启动lsp并attach，后续仅attach

local ok, jdtls = pcall(require, "jdtls")
if not ok then
  return
end

local utils = require("fengwk.utils")
local lspconfig = require("fengwk.plugins.lsp.lspconfig")

local java_home_preset = {
  java_home_5 = os.getenv("JAVA_HOME_5"),
  java_home_6 = os.getenv("JAVA_HOME_6"),
  java_home_7 = os.getenv("JAVA_HOME_7"),
  java_home_8 = os.getenv("JAVA_HOME_8"),
  java_home_9 = os.getenv("JAVA_HOME_9"),
  java_home_10 = os.getenv("JAVA_HOME_10"),
  java_home_11 = os.getenv("JAVA_HOME_11"),
  java_home_12 = os.getenv("JAVA_HOME_12"),
  java_home_13 = os.getenv("JAVA_HOME_13"),
  java_home_14 = os.getenv("JAVA_HOME_14"),
  java_home_15 = os.getenv("JAVA_HOME_15"),
  java_home_16 = os.getenv("JAVA_HOME_16"),
  java_home_17 = os.getenv("JAVA_HOME_17"),
  java_home_18 = os.getenv("JAVA_HOME_18"),
}

local stdpath_config = vim.fn.stdpath("config")
local stdpath_data = vim.fn.stdpath("data")
local stdpath_cache = vim.fn.stdpath("cache")

local java_home_17 = java_home_preset.java_home_17
local cp_sp = utils.os_name == "win" and ";" or ":"
local cp = "." .. cp_sp .. utils.fs_concat({ java_home_17, "lib", "dt.jar" }) .. cp_sp .. utils.fs_concat({ java_home_17, "lib", "tools.jar" })

local java = utils.fs_concat({ java_home_17, "bin", "java" })
local jdtls_home = utils.fs_concat({ stdpath_data, "mason", "packages", "jdtls" })
local lombok_jar = utils.fs_concat({ jdtls_home, "lombok.jar" })
local launcher_jar = vim.fn.glob(utils.fs_concat({ jdtls_home, "plugins", "org.eclipse.equinox.launcher_*.jar" }))
local config_dir = utils.fs_concat({ jdtls_home, (utils.os_name == "win" and "config_win" or "config_linux") })

local runtimes_preset = {
  {
    name = "J2SE-1.5",
    path = java_home_preset.java_home_5,
  },
  {
    name = "JavaSE-1.6",
    path = java_home_preset.java_home_6,
    sources = utils.fs_concat({ java_home_preset.java_home_6, "src.zip" }),
    javadoc = "https://docs.oracle.com/javase/6/docs/api",
  },
  {
    name = "JavaSE-1.7",
    path = java_home_preset.java_home_7,
    sources = utils.fs_concat({ java_home_preset.java_home_7, "src.zip" }),
    javadoc = "https://docs.oracle.com/javase/7/docs/api",
  },
  {
    name = "JavaSE-1.8",
    path = java_home_preset.java_home_8,
    sources = utils.fs_concat({ java_home_preset.java_home_8, "src.zip" }),
    javadoc = "https://docs.oracle.com/javase/8/docs/api",
    default = true,
  },
  {
    name = "JavaSE-9",
    path = java_home_preset.java_home_9,
    sources = utils.fs_concat({ java_home_preset.java_home_9, "lib", "src.zip" }),
    javadoc = "https://docs.oracle.com/javase/9/docs/api",
  },
  {
    name = "JavaSE-10",
    path = java_home_preset.java_home_10,
    sources = utils.fs_concat({ java_home_preset.java_home_10, "lib", "src.zip" }),
    javadoc = "https://docs.oracle.com/javase/10/docs/api",
  },
  {
    name = "JavaSE-11",
    path = java_home_preset.java_home_11,
    sources = utils.fs_concat({ java_home_preset.java_home_11, "lib", "src.zip" }),
    javadoc = "https://docs.oracle.com/javase/11/docs/api",
  },
  {
    name = "JavaSE-12",
    path = java_home_preset.java_home_12,
    sources = utils.fs_concat({ java_home_preset.java_home_12, "lib", "src.zip" }),
    javadoc = "https://docs.oracle.com/javase/12/docs/api",
  },
  {
    name = "JavaSE-13",
    path = java_home_preset.java_home_13,
    sources = utils.fs_concat({ java_home_preset.java_home_13, "lib", "src.zip" }),
    javadoc = "https://docs.oracle.com/javase/13/docs/api",
  },
  {
    name = "JavaSE-14",
    path = java_home_preset.java_home_14,
    sources = utils.fs_concat({ java_home_preset.java_home_14, "lib", "src.zip" }),
    javadoc = "https://docs.oracle.com/javase/14/docs/api",
  },
  {
    name = "JavaSE-15",
    path = java_home_preset.java_home_15,
    sources = utils.fs_concat({ java_home_preset.java_home_15, "lib", "src.zip" }),
    javadoc = "https://docs.oracle.com/javase/15/docs/api",
  },
  {
    name = "JavaSE-16",
    path = java_home_preset.java_home_16,
    sources = utils.fs_concat({ java_home_preset.java_home_16, "lib", "src.zip" }),
    javadoc = "https://docs.oracle.com/javase/16/docs/api",
  },
  {
    name = "JavaSE-17",
    path = java_home_preset.java_home_17,
    sources = utils.fs_concat({ java_home_preset.java_home_17, "lib", "src.zip" }),
    javadoc = "https://docs.oracle.com/javase/17/docs/api",
  },
  {
    name = "JavaSE-18",
    path = java_home_preset.java_home_18,
    sources = utils.fs_concat({ java_home_preset.java_home_18, "lib", "src.zip" }),
    javadoc = "https://docs.oracle.com/javase/18/docs/api",
  },
  {
    name = "JavaSE-19",
    path = java_home_preset.java_home_19,
    sources = utils.fs_concat({ java_home_preset.java_home_19, "lib", "src.zip" }),
    javadoc = "https://docs.oracle.com/javase/19/docs/api",
  },
}

local function build_runtimes()
  local runtimes = {}
  for _, item in pairs(runtimes_preset) do
    if item.path ~= nil then
      table.insert(runtimes, item)
    end
  end
  return runtimes
end

local M = {}

M.setup = function()

  -- 获取工作目录
  local root_dir = utils.find_root_dir({
    'build.xml', -- Ant
    "mvnw", -- Maven
    'pom.xml', -- Maven
    'settings.gradle', -- Gradle
    'settings.gradle.kts', -- Gradle
    "gradlew", -- Gradle
  })
  local is_single_file = root_dir == nil
  local workspace_dir = root_dir or vim.fn.expand("%:p")

  -- 转义工作目录作为名称
  local workspace_name = utils.path_to_name(workspace_dir)
  -- 数据目录
  local data_dir = utils.fs_concat({ stdpath_cache, "lsp", "jdtls", workspace_name })

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
    "-Xmx4G",
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
    lspconfig.on_attach(client, bufnr)

    -- jdtls特性
    jdtls.setup_dap({ hotcodereplace = "auto" })
    jdtls.setup.add_commands()

    -- https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration
    -- 注册用于调试的主类，如果是新增的main方法需要使用:JdtRefreshDebugConfigs命令刷新
    if not is_single_file then
      require("jdtls.dap").setup_dap_main_class_configs()
    end
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
      command! JdtRemoteDebug lua require'fengwk.plugins.lsp.lsp-jdtls.jdtls-command'.remote_debug_by_input()
      command! JdtDebug lua require'fengwk.plugins.lsp.lsp-jdtls.jdtls-command'.debug()
      " command! JdtA lua require'fengwk.plugins.lsp.lsp-jdtls.jdtls-command'.test()
    ]])

    -- 设置jdt的扩展快捷键，跳转到父类或接口
    vim.keymap.set("n", "gp", "<Cmd>lua require'jdtls'.super_implementation()<CR>", { noremap = true, silent = true, buffer = bufnr, desc = "Lsp Super Implementation" })

  end

  config.capabilities = lspconfig.make_capabilities()

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
        runtimes = build_runtimes(),
      },
    },
  }

  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  -- debug插件
  local bundles = {
      vim.fn.glob(utils.fs_concat({ stdpath_data, "mason", "packages", "java-debug-adapter", "extension", "server", "com.microsoft.java.debug.plugin-*.jar"})),
  }
  -- 单元测试插件
  vim.list_extend(bundles, vim.split(vim.fn.glob(utils.fs_concat({ stdpath_data, "mason", "packages", "java-test", "extension", "server", "*.jar" })), "\n"))

  local extendedClientCapabilities = jdtls.extendedClientCapabilities
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
  config.init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
  }

  -- This starts a new client & server,
  -- or attaches to an existing client & server depending on the `root_dir`.
  jdtls.start_or_attach(config)

end

return M
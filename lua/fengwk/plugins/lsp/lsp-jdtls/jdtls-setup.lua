-- 每个java缓冲区需要执行setup函数，首次执行将启动lsp并attach，后续仅attach

local ok, jdtls = pcall(require, "jdtls")
if not ok then
  return
end

local utils = require("fengwk.utils")
local lspconfig = require("fengwk.plugins.lsp.lspconfig")
local jdtls_enhancer = require("fengwk.plugins.lsp.lsp-jdtls.jdtls-enhancer")

local data_path = vim.fn.stdpath("data")
local cache_path = vim.fn.stdpath("cache")
local config_path = vim.fn.stdpath("config")

local java_home_preset = {
  java_home_5 = os.getenv("JAVA_HOME_5") or "",
  java_home_6 = os.getenv("JAVA_HOME_6") or "",
  java_home_7 = os.getenv("JAVA_HOME_7") or "",
  java_home_8 = os.getenv("JAVA_HOME_8") or "",
  java_home_9 = os.getenv("JAVA_HOME_9") or "",
  java_home_10 = os.getenv("JAVA_HOME_10") or "",
  java_home_11 = os.getenv("JAVA_HOME_11") or "",
  java_home_12 = os.getenv("JAVA_HOME_12") or "",
  java_home_13 = os.getenv("JAVA_HOME_13") or "",
  java_home_14 = os.getenv("JAVA_HOME_14") or "",
  java_home_15 = os.getenv("JAVA_HOME_15") or "",
  java_home_16 = os.getenv("JAVA_HOME_16") or "",
  java_home_17 = os.getenv("JAVA_HOME_17") or "",
  java_home_18 = os.getenv("JAVA_HOME_18") or "",
  java_home_19 = os.getenv("JAVA_HOME_19") or "",
  java_home_20 = os.getenv("JAVA_HOME_20") or "",
  java_home_21 = os.getenv("JAVA_HOME_21") or "",
  java_home_22 = os.getenv("JAVA_HOME_22") or "",
}

local java = vim.fs.joinpath(java_home_preset.java_home_21, "bin", "java")
local jdtls_home = vim.fs.joinpath(data_path, "mason", "packages", "jdtls")
local lombok_jar = vim.fs.joinpath(jdtls_home, "lombok.jar")
local launcher_jar = vim.fn.glob(vim.fs.joinpath(jdtls_home, "plugins", "org.eclipse.equinox.launcher_*.jar"))
local config_dir = vim.fs.joinpath(jdtls_home, (utils.sys.os == "win" and "config_win" or "config_linux"))

local runtimes_preset = {
  {
    name = "J2SE-1.5",
    path = java_home_preset.java_home_5,
  },
  {
    name = "JavaSE-1.6",
    path = java_home_preset.java_home_6,
    sources = vim.fs.joinpath(java_home_preset.java_home_6, "src.zip"),
    javadoc = "https://docs.oracle.com/javase/6/docs/api",
  },
  {
    name = "JavaSE-1.7",
    path = java_home_preset.java_home_7,
    sources = vim.fs.joinpath(java_home_preset.java_home_7, "src.zip"),
    javadoc = "https://docs.oracle.com/javase/7/docs/api",
  },
  {
    name = "JavaSE-1.8",
    path = java_home_preset.java_home_8,
    sources = vim.fs.joinpath(java_home_preset.java_home_8, "src.zip"),
    javadoc = "https://docs.oracle.com/javase/8/docs/api",
    default = true,
  },
  {
    name = "JavaSE-9",
    path = java_home_preset.java_home_9,
    sources = vim.fs.joinpath(java_home_preset.java_home_9, "lib", "src.zip"),
    javadoc = "https://docs.oracle.com/javase/9/docs/api",
  },
  {
    name = "JavaSE-10",
    path = java_home_preset.java_home_10,
    sources = vim.fs.joinpath(java_home_preset.java_home_10, "lib", "src.zip"),
    javadoc = "https://docs.oracle.com/javase/10/docs/api",
  },
  {
    name = "JavaSE-11",
    path = java_home_preset.java_home_11,
    sources = vim.fs.joinpath(java_home_preset.java_home_11, "lib", "src.zip"),
    javadoc = "https://docs.oracle.com/javase/11/docs/api",
  },
  {
    name = "JavaSE-12",
    path = java_home_preset.java_home_12,
    sources = vim.fs.joinpath(java_home_preset.java_home_12, "lib", "src.zip"),
    javadoc = "https://docs.oracle.com/javase/12/docs/api",
  },
  {
    name = "JavaSE-13",
    path = java_home_preset.java_home_13,
    sources = vim.fs.joinpath(java_home_preset.java_home_13, "lib", "src.zip"),
    javadoc = "https://docs.oracle.com/javase/13/docs/api",
  },
  {
    name = "JavaSE-14",
    path = java_home_preset.java_home_14,
    sources = vim.fs.joinpath(java_home_preset.java_home_14, "lib", "src.zip"),
    javadoc = "https://docs.oracle.com/javase/14/docs/api",
  },
  {
    name = "JavaSE-15",
    path = java_home_preset.java_home_15,
    sources = vim.fs.joinpath(java_home_preset.java_home_15, "lib", "src.zip"),
    javadoc = "https://docs.oracle.com/javase/15/docs/api",
  },
  {
    name = "JavaSE-16",
    path = java_home_preset.java_home_16,
    sources = vim.fs.joinpath(java_home_preset.java_home_16, "lib", "src.zip"),
    javadoc = "https://docs.oracle.com/javase/16/docs/api",
  },
  {
    name = "JavaSE-17",
    path = java_home_preset.java_home_17,
    sources = vim.fs.joinpath(java_home_preset.java_home_17, "lib", "src.zip"),
    javadoc = "https://docs.oracle.com/javase/17/docs/api",
  },
  {
    name = "JavaSE-18",
    path = java_home_preset.java_home_18,
    sources = vim.fs.joinpath(java_home_preset.java_home_18, "lib", "src.zip"),
    javadoc = "https://docs.oracle.com/javase/18/docs/api",
  },
  {
    name = "JavaSE-19",
    path = java_home_preset.java_home_19,
    sources = vim.fs.joinpath(java_home_preset.java_home_19, "lib", "src.zip"),
    javadoc = "https://docs.oracle.com/javase/19/docs/api",
  },
  {
    name = "JavaSE-20",
    path = java_home_preset.java_home_20,
    sources = vim.fs.joinpath(java_home_preset.java_home_20, "lib", "src.zip"),
    javadoc = "https://docs.oracle.com/javase/20/docs/api",
  },
  {
    name = "JavaSE-21",
    path = java_home_preset.java_home_21,
    sources = vim.fs.joinpath(java_home_preset.java_home_21, "lib", "src.zip"),
    javadoc = "https://docs.oracle.com/javase/21/docs/api",
  },
  {
    name = "JavaSE-22",
    path = java_home_preset.java_home_22,
    sources = vim.fs.joinpath(java_home_preset.java_home_22, "lib", "src.zip"),
    javadoc = "https://docs.oracle.com/javase/22/docs/api",
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

local function setup()

  -- 获取工作目录
  local root_dir = utils.fs.root_dir {
    "build.xml", -- Ant
    "mvnw", -- Maven
    "pom.xml", -- Maven
    "settings.gradle", -- Gradle
    "settings.gradle.kts", -- Gradle
    "gradlew", -- Gradle
  }
  local single_file = root_dir == nil
  local workspace_dir = root_dir or vim.fn.getcwd()
    -- 转义工作目录作为名称
  local workspace_name = utils.fs.escape_filename(workspace_dir)
  -- 数据目录
  local data_dir = vim.fs.joinpath(cache_path, "lsp", "jdtls", workspace_name)

  -- java全局首选项
  local java_settings_url = vim.fs.joinpath(config_path, "lua", "fengwk", "plugins", "lsp", "lsp-jdtls", "org.eclipse.jdt.core.prefs")

  -- jdtls配置
  local config = {}

  -- jdtls启动命令
  config.cmd = {
    java,
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx2G",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-javaagent:" .. lombok_jar,
    "-jar", launcher_jar,
    "-configuration", config_dir,
    "-data", data_dir,
  }

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  config.on_attach = function(client, bufnr)
    lspconfig.build_on_attach({
      root = workspace_dir,
      single_file = single_file,
    })(client, bufnr)

    -- jdtls特性
    jdtls.setup_dap({ hotcodereplace = "auto" })
    jdtls.setup.add_commands()

    -- https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration
    -- 注册用于调试的主类，如果是新增的main方法需要使用:JdtRefreshDebugConfigs命令刷新
    require("jdtls.dap").setup_dap_main_class_configs()
    -- if not single_file then
    --   require("jdtls.dap").setup_dap_main_class_configs()
    -- end

    -- 注册调试命令
    vim.api.nvim_create_user_command("JdtTestClass", function() require("jdtls").test_class() end, {})
    vim.api.nvim_create_user_command("JdtTestMethod", function() require("jdtls").test_nearest_method() end, {})
    vim.api.nvim_create_user_command("JdtRemoteDebug", function() require("fengwk.plugins.lsp.lsp-jdtls.jdtls-enhancer").remote_debug() end, {})
    vim.api.nvim_create_user_command("JdtDebug", function() require("fengwk.plugins.lsp.lsp-jdtls.jdtls-enhancer").debug() end, {})

    -- 拷贝引用
    vim.api.nvim_create_user_command("JdtCopyReference", function()
      require("fengwk.plugins.lsp.lsp-jdtls.jdtls-enhancer").copy_reference()
    end, {})
    -- 与ChatGPT run冲突
    -- vim.keymap.set("n", "<leader>cr", function()
    --   require("fengwk.plugins.lsp.lsp-jdtls.jdtls-enhancer").copy_reference()
    -- end, { silent = true, desc = "Jdt Copy Reference" })

    -- 跳转到目标
    -- TODO 需要想办法定位location
    -- vim.keymap.set("n", "gf", function()
    --   utils.motion.operator(function(textobject)
    --     jdtls_enhancer.jump_to_location(table.concat(textobject, ""))
    --   end)
    -- end)
    -- vim.keymap.set("n", "gff", function()
    --   utils.motion.line(function(textobject)
    --     jdtls_enhancer.jump_to_location(table.concat(textobject, ""))
    --   end)
    -- end)
    -- vim.keymap.set("n", "gF", function()
    --   utils.motion.eol(function(textobject)
    --     jdtls_enhancer.jump_to_location(table.concat(textobject, ""))
    --   end)
    -- end)
    -- vim.keymap.set("v", "gf", function()
    --   utils.motion.visual(function(textobject)
    --     jdtls_enhancer.jump_to_location(table.concat(textobject, ""))
    --   end)
    -- end)

    -- 自动导包
    -- vim.keymap.set("n", "<leader>i", function ()
    --   require("jdtls").auto_organize_imports()
    -- end, { silent = true, buffer = bufnr, desc = "Auto Organize Imports" })
    -- vim.api.nvim_create_augroup("jdtls_auto_organize_imports", { clear = true })
    -- vim.api.nvim_create_autocmd(
    -- { "InsertLeave" },
    -- { group = "jdtls_auto_organize_imports", buffer = bufnr, callback = function()
    --   vim.defer_fn(function()
    --     if vim.api.nvim_get_mode().mode == "n" then
    --       require("jdtls").auto_organize_imports()
    --     end
    --   end, 500)
    -- end})
    -- 设置jdt的扩展快捷键，跳转到父类或接口
    vim.keymap.set("n", "gp", "<Cmd>lua require'jdtls'.super_implementation()<CR>", { silent = true, buffer = bufnr, desc = "Lsp Super Implementation" })
    -- inherited_members扩展
    vim.keymap.set("n", "gS", "<Cmd>Telescope jdtls inherited_members<CR>", { silent = true, buffer = bufnr, desc = "Lsp Inherited Members" })

    -- 刷新配置
    vim.keymap.set("n", "<leader>rr", "<Cmd>JdtUpdateConfig<CR>", { silent = true, buffer = bufnr, desc = "Lsp Update Config" })
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
        },
        -- 推测方法参数进行补全
        guessMethodArguments = true,
      },
      sources = {
        -- 低于指定阈值，不在import中使用*
        organizeImports = {
          starThreshold = 5,
          staticStarThreshold = 5,
        },
      },
      configuration = {
        -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
        -- And search for `interface RuntimeOption`
        -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
        runtimes = build_runtimes(),
      },
      format = {
        enabled = true,
        -- 插入空格而不是tab
        insertSpaces = true,
      },
      settings = {
        -- https://github.com/eclipse/eclipse.jdt.ls/issues/1892#issuecomment-929715918
        -- https://github.com/redhat-developer/vscode-java/wiki/Settings-Global-Preferences
        url = java_settings_url
      },
      maven = {
        downloadSources = true,
        updateSnapshots = true,
      },
      -- https://github.com/redhat-developer/vscode-java/issues/1470
      -- https://github.com/redhat-developer/vscode-java/wiki/Predefined-Variables-for-Java-Template-Snippets
      templates = {
        typeComment = {
          "/**",
          " * ${type_name}",
          " * @author ${user}",
          " */",
        },
      },
    },
  }

  local bundles = {}
  -- debug插件
  -- https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  vim.list_extend(bundles, vim.split(vim.fn.glob(vim.fs.joinpath(data_path, "mason", "packages", "java-debug-adapter", "extension", "server", "*.jar")), "\n"))
  -- 单元测试插件
  vim.list_extend(bundles, vim.split(vim.fn.glob(vim.fs.joinpath(data_path, "mason", "packages", "java-test", "extension", "server", "*.jar")), "\n"))
  -- eclipse插件支持
  -- https://github.com/eclipse/eclipse.jdt.ls/blob/master/CONTRIBUTING.md
  vim.list_extend(bundles, vim.split(vim.fn.glob(vim.fs.joinpath(config_path, "lua", "fengwk", "plugins", "lsp", "lsp-jdtls", "eclipse-pde", "*.jar")), "\n"))

  local extendedClientCapabilities = vim.deepcopy(jdtls.extendedClientCapabilities)
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
  config.init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
  }

  -- This starts a new client & server,
  -- or attaches to an existing client & server depending on the `root_dir`.
  jdtls.start_or_attach(config)

end

vim.api.nvim_create_augroup("user_jdtls_setup", { clear = true })
-- java or ant文件启动jdtls
vim.api.nvim_create_autocmd(
  { "FileType" },
  { group = "user_jdtls_setup", pattern = "java,ant", callback = setup })
-- pom.xml文件启动jdtls
vim.api.nvim_create_autocmd(
  { "FileType" },
  { group = "user_jdtls_setup", pattern = "xml", callback = function()
    local name = vim.fn.expand("%:t")
    if name == "pom.xml" then
      setup()
    end
  end})
-- vim.api.nvim_create_autocmd(
--   { "FileType" },
--   { group = "user_jdtls_setup", pattern = "groovy", callback = function()
--     local name = vim.fn.expand("%:t")
--     if name == "build.gradle" then
--       setup()
--     end
--   end})

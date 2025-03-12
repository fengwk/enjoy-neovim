-- https://github.com/jackMort/ChatGPT.nvim
local ok, chatgpt = pcall(require, "chatgpt")
if not ok then
  return
end

local utils = require("fengwk.utils")

local chatgt_actions_json = vim.fs.joinpath(vim.fn.stdpath("config"), "lib", "chatgpt_actoins.json")

local DEFAULT_SYSTEM_MESSAGE = "如果user没有要求，回答语言的组织尽量简洁精炼。"

chatgpt.setup {
  yank_register = "+",
  edit_with_instructions = {
    diff = false,
    keymaps = {
      close = { "<C-c>", "<C-q>" },
      close_n = { "<Esc>", "q" },    -- normal模式下关闭
      accept = "<C-y>",              -- 将修改内容替换到文本中
      toggle_diff = "<C-d>",         -- 对比内容
      toggle_help = "<C-h>",         -- 打开帮助
      toggle_settings = "<C-o>",
      cycle_windows = "<Tab>",       -- 在不同窗口间切换
      use_output_as_input = "<C-e>", -- 将回复内容作为新的输入，不能使用默认的<C-i>，因为<C-i>等价于<Tab>
    },
  },
  chat = {
    -- welcome_message = WELCOME_MESSAGE,
    default_system_message = DEFAULT_SYSTEM_MESSAGE,
    loading_text = "Loading, please wait ...",
    question_sign = "",
    answer_sign = "ﮧ",
    border_left_sign = "",
    border_right_sign = "",
    max_line_length = 120,
    sessions_window = {
      active_sign = "  ",
      inactive_sign = "  ",
      current_line_sign = "",
      border = {
        style = vim.g.__border,
        text = {
          top = " Sessions ",
        },
      },
      win_options = {
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,SignColumn:MySignColumn,FoldColumn:MyFoldColumn",
      },
    },
    keymaps = {
      close = { "<C-c>", "<C-q>" },
      close_n = { "<Esc>", "q" },
      yank_last = "<C-y>",
      yank_last_code = "<C-k>",
      scroll_up = "<C-u>",     -- 向上滚动文本
      scroll_down = "<C-d>",   -- 向下滚动文本
      new_session = "<C-n>",   -- 新建一个session
      cycle_windows = "<Tab>", -- 在不同创建间切换
      cycle_modes = "<C-f>",   -- 切换窗口模式，居中和靠右
      next_message = "<C-j>",  -- TODO ?
      prev_message = "<C-k>",  -- TODO ?
      select_session = { "<Space>", "<CR>" },
      rename_session = "r",
      delete_session = "d",
      draft_message = "<C-r>",           -- 消息面板
      edit_message = "e",                -- 在消息面板编辑消息
      delete_message = "d",              -- 在消息面板删除消息
      toggle_settings = "<C-o>",         -- 设置开关
      toggle_sessions = "<C-p>",         -- session开关
      toggle_help = "<C-h>",             -- 帮助开关
      toggle_message_role = "<C-r>",     -- 切换当前发言角色，可以使用AI身份发言
      toggle_system_role_open = "<C-s>", -- 打开系统发言面板用于提示对话
      stop_generating = "<C-x>",         -- 停止生成消息
    }
  },
  popup_layout = {
    default = "center",
    center = {
      width = "80%",
      height = "80%",
    },
    right = {
      width = "30%",
      width_settings_open = "50%",
    },
  },
  popup_window = {
    border = {
      highlight = "FloatBorder",
      style = vim.g.__border,
      text = {
        top = " ChatGPT ",
      },
    },
    win_options = {
      wrap = true,
      linebreak = true,
      foldcolumn = "1",
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder,SignColumn:MySignColumn,FoldColumn:MyFoldColumn",
    },
    buf_options = {
      filetype = "markdown",
    },
  },
  system_window = {
    border = {
      highlight = "FloatBorder",
      style = vim.g.__border,
      text = {
        top = " SYSTEM ",
      },
    },
    win_options = {
      wrap = true,
      linebreak = true,
      foldcolumn = "2",
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder,SignColumn:MySignColumn,FoldColumn:MyFoldColumn",
    },
  },
  popup_input = {
    prompt = "  ",
    border = {
      highlight = "FloatBorder",
      style = "rounded",
      text = {
        top_align = "center",
        top = " Prompt ",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder,SignColumn:MySignColumn,FoldColumn:MyFoldColumn",
    },
    submit = "<C-Enter>",
    submit_n = "<Enter>",
    max_visible_lines = 20,
  },
  settings_window = {
    border = {
      style = "rounded",
      text = {
        top = " Settings ",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder,SignColumn:MySignColumn,FoldColumn:MyFoldColumn",
    },
  },
  help_window = {
    setting_sign = "  ",
    border = {
      style = "rounded",
      text = {
        top = " Help ",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder,SignColumn:MySignColumn,FoldColumn:MyFoldColumn",
    },
  },
  openai_params = {
    -- model = "gpt-4-0613",
    -- model = "gpt-3.5-turbo-16k",
    -- model = "gpt-3.5-turbo",
    -- model = "deepseek-chat",
    model = "deepseek-coder-v2-32k:latest",
    temperature = 1.0,     -- 值越大越有随机性，建议和top_p修改一个即可
    top_p = 1.0,           -- 值越大越有多样性
    presence_penalty = 0,  -- 话题新鲜度，值越大, 越可能是用到新的话题
    frequency_penalty = 0, -- 频率惩罚，值越大, 越倾向于生成不常见的词汇和表达方式
    max_tokens = 4096,     -- 用于限制单次回复的最大长度
    n = 1,
  },
  openai_edit_params = {
    -- model = "gpt-4-0613",
    -- model = "gpt-3.5-turbo-16k",
    -- model = "gpt-3.5-turbo",
    model = "deepseek-chat",
    temperature = 1.0,    -- 值越大越有随机性，建议和top_p修改一个即可
    top_p = 1.0,          -- 值越大越有多样性
    presence_penalty = 0, -- deepseek-chat中frequency_penalty和frequency_penalty取默认值0否则会返回重复的内容
    frequency_penalty = 0,
    max_tokens = 4096,    -- 用于限制单次回复的最大长度
    n = 1,
  },
  use_openai_functions_for_edits = false, -- 是否使用function call，这个选项目前没必要因为直接应用修改就可以了，没必要让gpt调用修改函数
  ignore_default_actions_path = true,     -- 忽略默认的actoins
  actions_paths = {
    chatgt_actions_json
  },
  show_quickfixes_cmd = "copen", -- 指定quickfix打开的命令
  predefined_chat_gpt_prompts = "https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv",
  highlights = {
    help_key = "@symbol",
    help_description = "@comment",
  },
}

local function run_list(x)
  if x then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "x", true)
  end
  local actions = require "chatgpt.flows.actions"
  local run_actions = {}
  for k, _ in pairs(actions.read_actions()) do
    table.insert(run_actions, k)
  end
  table.sort(run_actions)
  vim.ui.select(run_actions, {}, function(a)
    if a then
      if x then
        vim.api.nvim_feedkeys("gv", "n", false)
      end
      vim.cmd("ChatGPTRun " .. a)
    end
  end)
end

vim.keymap.set("n", "<leader>ct", "<Cmd>ChatGPT<CR>", { silent = true, desc = "GPT Chat" })
vim.keymap.set("v", "<leader>ct", function()
  utils.motion.visual(function(args)
    local text = table.concat(args.textobject, "\n")
    local system_prompt = [[%s现在我们针对以下内容展开讨论:

    ```
    %s
    ```]]
    -- 使用vim.schedule调度，避免序列串到chatgpt输入框中
    vim.schedule(function()
      chatgpt.open_chat_with({
        new_session = true,
        open_system_panel = "open",
        messages = {
          { role = "system", content = string.format(system_prompt, DEFAULT_SYSTEM_MESSAGE, text) }
        },
      })
      end)
    end)
  end, { desc = "GPT Chat With" })
vim.keymap.set("n", "<leader>cc", "<Cmd>ChatGPTRun complete_code<CR>", { silent = true, desc = "GPT Complete Code" })
vim.keymap.set("x", "<leader>ce", "<Esc><Cmd>ChatGPTEditWithInstructions<CR>",
  { silent = true, desc = "GPT Edit With Instructions" })
vim.keymap.set("x", "<leader>ck", "<Cmd>ChatGPTRun explain_code_cn<CR>", { silent = true, desc = "GPT Explain Code CN" })
vim.keymap.set("n", "<leader>cr", run_list, { desc = "ChatGPTRun" })
vim.keymap.set("x", "<leader>cr", function() run_list(true) end, { desc = "ChatGPTRun" })

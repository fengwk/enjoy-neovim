local ok, chatgpt = pcall(require, "chatgpt")
if not ok then
  return
end

local utils = require("fengwk.utils")
local stdpath_config = vim.fn.stdpath("config")
local chatgt_actions_json = utils.fs_concat({ stdpath_config, "lib", "chatgpt_actoins.json" })

chatgpt.setup({
  yank_register = "+",
  edit_with_instructions = {
    diff = false,
    keymaps = {
      accept = "<C-y>", -- 将修改内容替换到文本中
      toggle_diff = "<C-d>", -- 对比内容
      toggle_settings = "<C-o>",
      cycle_windows = "<Tab>", -- 在不同窗口间切换
      use_output_as_input = "<C-i>", -- 将回复内容作为新的输入
    },
  },
  chat = {
    welcome_message = WELCOME_MESSAGE,
    loading_text = "Loading, please wait ...",
    question_sign = "",
    answer_sign = "ﮧ",
    max_line_length = 120,
    sessions_window = {
      border = {
        style = "rounded",
        text = {
          top = " Sessions ",
        },
      },
      win_options = {
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
      },
    },
    keymaps = {
      -- close = { --[["<C-c>",--]] "<C-q>" },
      close = { "<C-c>", "<C-q>" },
      yank_last = "<C-y>",
      yank_last_code = "<C-k>",
      scroll_up = "<C-u>",
      scroll_down = "<C-d>",
      new_session = "<C-n>",
      cycle_windows = "<Tab>",
      cycle_modes = "<C-f>",
      select_session = { "<Space>", "<CR>" },
      rename_session = "r",
      delete_session = "d",
      draft_message = "<C-d>",
      toggle_settings = "<C-o>",
      toggle_message_role = "<C-r>",
      toggle_system_role_open = "<C-s>",
    },
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
      style = "rounded",
      text = {
        top = " ChatGPT ",
      },
    },
    win_options = {
      wrap = true,
      linebreak = true,
      foldcolumn = "1",
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    },
    buf_options = {
      filetype = "markdown",
    },
  },
  system_window = {
    border = {
      highlight = "FloatBorder",
      style = "rounded",
      text = {
        top = " SYSTEM ",
      },
    },
    win_options = {
      wrap = true,
      linebreak = true,
      foldcolumn = "2",
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
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
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    },
    submit = "<C-Enter>",
    submit_n = "<Enter>",
  },
  settings_window = {
    border = {
      style = "rounded",
      text = {
        top = " Settings ",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    },
  },
  openai_params = {
    model = "gpt-3.5-turbo",
    frequency_penalty = 0,
    presence_penalty = 0,
    max_tokens = 300,
    temperature = 0,
    top_p = 1,
    n = 1,
  },
  openai_edit_params = {
    model = "code-davinci-edit-001",
    temperature = 0,
    top_p = 1,
    n = 1,
  },
  actions_paths = {
    chatgt_actions_json
  },
  show_quickfixes_cmd = "copen", -- 指定quickfix打开的命令
  predefined_chat_gpt_prompts = "https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv",
})

-- vim.keymap.set("i", "<C-c>", "<Esc><C-c>", { silent = true, desc = "GPT Chat" })
vim.keymap.set("n", "<leader>ct", "<Cmd>ChatGPT<CR>", { silent = true, desc = "GPT Chat" })
vim.keymap.set("n", "<leader>cc", "<Cmd>ChatGPTRun complete_code<CR>", { silent = true, desc = "GPT Complete Code" })
vim.keymap.set("x", "<leader>ce", "<Esc><Cmd>ChatGPTEditWithInstructions<CR>", { silent = true, desc = "GPT Edit With Instructions" })
-- vim.keymap.set("x", "K", "<Cmd>ChatGPTRun explain_code_cn<CR>", { silent = true, desc = "GPT Explain Code CN" })
vim.keymap.set("x", "<leader>ck", "<Cmd>ChatGPTRun explain_code_cn<CR>", { silent = true, desc = "GPT Explain Code CN" })
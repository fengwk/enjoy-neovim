-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects

require("nvim-treesitter.configs").setup {
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["aC"] = "@conditional.outer",
        ["iC"] = "@conditional.inner",
      },
      -- You can choose the select mode (default is charwise 'v')
      selection_modes = {
        -- ['@parameter.outer'] = 'v', -- charwise
        -- ['@function.outer'] = 'V', -- linewise
        -- ['@class.outer'] = '<c-v>', -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding xor succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      include_surrounding_whitespace = false,
    },

    -- 在textobjects之间移动
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer",
        ["]a"] = "@parameter.inner",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]C"] = "@class.outer",
        ["]A"] = "@parameter.inner",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
        ["[a"] = "@parameter.inner",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[C"] = "@class.outer",
        ["[A"] = "@parameter.inner",
      },
    },

    -- 交换textobjects位置
    swap = {
      enable = true,
      swap_next = {
        ["<leader>sf"] = "@function.outer",
        ["<leader>sc"] = "@class.outer",
        ["<leader>sa"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>sF"] = "@function.outer",
        ["<leader>sC"] = "@class.outer",
        ["<leader>sA"] = "@parameter.inner",
      },
    },
  },
}
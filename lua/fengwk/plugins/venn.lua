-- https://github.com/jbyuki/venn.nvim

-- venn.nvim: enable or disable keymappings
function _G._veen_toggle()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if venn_enabled == "nil" then
        vim.b.venn_enabled = true
        vim.cmd[[setlocal ve=all]]
        -- draw a line on HJKL keystokes
        vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
        -- draw a box by pressing "" with visual selection
        vim.api.nvim_buf_set_keymap(0, "v", "b", ":VBox<CR>", { noremap = true, silent = true })
        vim.notify("Veen Enabled")
    else
        vim.cmd[[setlocal ve=]]
        vim.cmd[[mapclear <buffer>]]
        vim.b.venn_enabled = nil
        vim.notify("Veen Disabled")
    end
end

-- toggle keymappings for venn using <leader>v
vim.keymap.set("n", "<leader>v", "<Cmd>VeenToggle<CR>", { silent = true, desc = "Toggle Veen" })

vim.cmd([[
  command! VeenToggle :lua _G._veen_toggle()
]])
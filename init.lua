vim.g.deprecation_warnings = false
vim.opt.cmdheight = 0
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.python3_host_prog = "/opt/homebrew/opt/python@3.12/bin/python3.12"

-- Move by word in Insert Mode (Handles Karabiner's Option+Arrow output)
vim.keymap.set("i", "<M-Left>", "<C-o>b", { desc = "Move back one word" })
vim.keymap.set("i", "<M-Right>", "<C-o>w", { desc = "Move forward one word" })
vim.g.copilot_enabled = false

local function set_copilot_all_buffers(enabled)
    -- Apply to all existing open buffers
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
            vim.api.nvim_buf_set_var(buf, "copilot_enabled", enabled)
        end
    end
    vim.g.copilot_enabled = enabled
end

local function toggle_copilot()
    if vim.g.copilot_enabled == true then
        set_copilot_all_buffers(false)
        print("AI Disabled Everywhere")
    else
        set_copilot_all_buffers(true)
        print("AI Enabled Everywhere")
    end
end

-- Keymap
vim.keymap.set("n", "<leader>ct", toggle_copilot, { noremap = true, silent = true })

-- Apply state to new buffers as they're opened
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        if vim.g.copilot_enabled == false then
            vim.b.copilot_enabled = false
        else
            vim.b.copilot_enabled = true
        end
    end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- 2. Load Plugins
require("lazy").setup({
    spec = {
        { import = "plugins" },
    },
    ui = { border = "rounded" },
    rocks = {
        hererocks = false,
    },
})

-- 3. Standard Options & Provider Config
vim.opt.list = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.completeopt = "menu,menuone,noselect"

-- Python & Browser for LeetCode
vim.g.python3_host_prog = "/opt/homebrew/bin/python3"
vim.g.leetcode_browser = "chrome"

-- 4. Load Custom Modules (Safe Loading)
local modules = { "settings", "keymap", "filetype", "snippets", "config.quit" }
for _, mod in ipairs(modules) do
    local status, err = pcall(require, mod)
    if not status then
        vim.notify("Error loading " .. mod .. ": " .. err, vim.log.levels.WARN)
    end
end

-- 5. Auto-format on BufWritePre
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        if vim.bo.modifiable then
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients > 0 then
                local pos = vim.api.nvim_win_get_cursor(0)
                vim.lsp.buf.format({ async = false })
                pcall(vim.api.nvim_win_set_cursor, 0, pos)
            end
        end
    end,
})

-- Hide whitespace characters and ensure syntax is on
vim.cmd("syntax on")
vim.cmd("highlight Whitespace ctermfg=NONE guifg=NONE")

-- Sync clipboard between OS and Neovim
vim.opt.clipboard = "unnamedplus"

-- Auto save when leaving insert mode
vim.api.nvim_create_autocmd({ "InsertLeave", "CursorHold" }, {
    callback = function()
        if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" then
            vim.cmd("silent! write")
        end
      end,
})

-- Keymaps
vim.keymap.set({ "n", "v", "i" }, "<D-a>", "<Esc>ggVG", { desc = "Select all" })
vim.keymap.set("v", "<D-c>", '\"+y', { desc = "Copy to clipboard" })
vim.keymap.set({ "n", "v" }, "<D-v>", '\"+p', { desc = "Paste from clipboard" })
vim.keymap.set("i", "<D-v>", "<C-r>+", { desc = "Paste from clipboard" })
vim.keymap.set("v", "<D-x>", '\"+x', { desc = "Cut to clipboard" })
vim.keymap.set("n", "<D-z>", "u", { noremap = true })
vim.keymap.set("i", "<D-z>", "<C-o>u", { noremap = true })
vim.keymap.set("v", "<D-z>", "<Esc>u", { noremap = true })
vim.keymap.set("n", "<D-S-z>", "<C-r>", { noremap = true })
vim.keymap.set("i", "<D-S-z>", "<C-o><C-r>", { noremap = true })
vim.keymap.set("v", "<D-S-z>", "<Esc><C-r>", { noremap = true })
vim.keymap.set("c", "<M-Left>", "<S-Left>", { desc = "Move back one word in cmd" })
vim.keymap.set("c", "<M-Right>", "<S-Right>", { desc = "Move forward one word in cmd" })
vim.keymap.set("n", "<M-f>", "w", { noremap = true })
vim.keymap.set("n", "<M-b>", "b", { noremap = true })
vim.keymap.set("i", "<M-f>", "<C-o>w", { noremap = true })
vim.keymap.set("i", "<M-b>", "<C-o>b", { noremap = true })
vim.keymap.set({ "n", "i", "v" }, "<S-Left>", "<Left>", { noremap = true })
vim.keymap.set({ "n", "i", "v" }, "<S-Right>", "<Right>", { noremap = true })
vim.keymap.set({ "n", "i", "v" }, "<S-Up>", "<Up>", { noremap = true })
vim.keymap.set({ "n", "i", "v" }, "<S-Down>", "<Down>", { noremap = true })
vim.keymap.set("v", "<BS>", '\"_d', { noremap = true })
vim.keymap.set("v", "<Delete>", '\"_d', { noremap = true })
vim.opt.number = true

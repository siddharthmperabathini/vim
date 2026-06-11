vim.api.nvim_create_user_command("A", function()
  -- Close NvimTree if it's open
  local ok, api = pcall(require, "nvim-tree.api")
  if ok then
    api.tree.close()
  end

  -- Format current buffer (if supported)
  local clients = vim.lsp.get_active_clients({ bufnr = 0 })
  for _, client in ipairs(clients) do
    if client.supports_method("textDocument/formatting") then
      vim.lsp.buf.format({ async = false })
      break
    end
  end

  -- Save buffer if modified
  if vim.bo.modified then
    vim.cmd("write")
  end

  -- Quit all
  vim.cmd("qa")
end, {})

-- Set <leader>A as a shortcut to quit everything
vim.api.nvim_set_keymap("n", "<leader>A", ":A<CR>", { noremap = true, silent = true })


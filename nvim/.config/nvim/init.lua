-- Source Vimscript configuration
vim.cmd('source ~/.config/nvim/init.vim.bak')

-- Configure `ruff-lsp` using new Neovim 0.11+ API
-- See: :help lspconfig-nvim-0.11
vim.lsp.config.ruff = {
  cmd = { 'ruff-lsp' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
  settings = {
    args = {},
  },
}

-- Auto-format on save for ruff
local augroup = vim.api.nvim_create_augroup('LspFormatting', { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
  group = augroup,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.name == 'ruff' and client.supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf })
        end,
      })
    end
  end,
})

-- Enable ruff LSP for Python files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.lsp.enable('ruff')
  end,
})


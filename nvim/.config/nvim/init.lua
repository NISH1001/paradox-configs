-- Source legacy vimscript configuration
vim.cmd('source ~/.config/nvim/init.vim.bak')

-- ============================================================================
-- Completion: blink.cmp (Rust-backed, replaces deoplete)
-- ============================================================================
-- Wrapped in pcall so the first `nvim` launch (before :PlugInstall) doesn't
-- blow up when the plugin isn't on the runtimepath yet.
local ok_blink, blink = pcall(require, 'blink.cmp')
if ok_blink then
  blink.setup({
    keymap = { preset = 'default' },  -- <C-n>/<C-p> navigate, <C-y> confirm, <C-e> cancel
    appearance = { nerd_font_variant = 'mono' },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    signature = { enabled = true },
  })
end

-- ============================================================================
-- LSP: ruff (lint + format) + basedpyright (types + navigation + completion)
-- ============================================================================
-- Advertise blink.cmp's extra completion capabilities to every server.
local capabilities = vim.lsp.protocol.make_client_capabilities()
if ok_blink then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

-- ruff: linting, formatting, import sorting, quick-fixes
vim.lsp.config.ruff = {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
  capabilities = capabilities,
}

-- basedpyright: type checking, go-to-definition, hover, completion
vim.lsp.config.basedpyright = {
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
  capabilities = capabilities,
  settings = {
    basedpyright = {
      -- Let ruff own formatting & import organization; basedpyright handles types only.
      disableOrganizeImports = true,
      analysis = {
        typeCheckingMode = 'basic',          -- 'off' | 'basic' | 'standard' | 'strict' | 'all'
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
    },
  },
}

vim.lsp.enable({ 'ruff', 'basedpyright' })

-- ============================================================================
-- LSP UX: format-on-save (ruff only) + handy keymaps on attach
-- ============================================================================
local augroup = vim.api.nvim_create_augroup('LspFormatting', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = augroup,
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    -- basedpyright provides hover/defs; ruff provides diagnostics/hover for lints.
    -- Disable basedpyright's hover so ruff's lint-code hover (e.g. F401 details) wins
    -- on lines where both apply. Comment the next line out if you prefer type hover.
    if client.name == 'basedpyright' then
      client.server_capabilities.hoverProvider = false
    end

    -- Format on save via ruff (organizes imports + formats).
    if client.name == 'ruff' and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, name = 'ruff' })
          -- Also run ruff's "source.organizeImports" code action if available.
          vim.lsp.buf.code_action({
            context = { only = { 'source.organizeImports.ruff' }, diagnostics = {} },
            apply = true,
          })
        end,
      })
    end

    -- Buffer-local LSP keymaps
    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
    end
    map('gd', vim.lsp.buf.definition,      'LSP: go to definition')
    map('gD', vim.lsp.buf.declaration,     'LSP: go to declaration')
    map('gi', vim.lsp.buf.implementation,  'LSP: go to implementation')
    map('gr', vim.lsp.buf.references,      'LSP: references')
    map('K',  vim.lsp.buf.hover,           'LSP: hover')
    map('<leader>rn', vim.lsp.buf.rename,  'LSP: rename symbol')
    map('<leader>ca', vim.lsp.buf.code_action, 'LSP: code action')
    map('[d', vim.diagnostic.goto_prev,    'Diagnostic: previous')
    map(']d', vim.diagnostic.goto_next,    'Diagnostic: next')
  end,
})

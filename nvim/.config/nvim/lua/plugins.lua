-- ============================================================================
-- Plugin spec for lazy.nvim
-- ============================================================================
-- Migration notes:
--  - 1:1 port of miscconfigs/plug.vim active plugins
--  - `lazy = false` by default: matches vim-plug's eager-load behavior so the
--    vimscript configuration (sourced from init.vim.bak) still sees plugin
--    commands/functions at startup. Individual plugins opt into lazy-loading
--    via `cmd`, `ft`, `event`, or `keys`.
--  - vim-plug `do:` hooks map to lazy.nvim `build`.
-- ============================================================================

return {
  -- Completion (Rust-backed, replaces deoplete + deoplete-jedi + tern)
  { 'saghen/blink.cmp', version = '*' },

  -- Fuzzy finders
  { 'ctrlpvim/ctrlp.vim' },
  { 'junegunn/fzf', dir = '~/.fzf', build = './install --all' },
  { 'junegunn/fzf.vim' },

  -- UI
  { 'vim-airline/vim-airline' },
  { 'nvimdev/dashboard-nvim' },
  { 'Yggdroot/indentLine' },
  { 'ryanoasis/vim-devicons' },
  { 'nvim-tree/nvim-web-devicons' },
  { 'nvim-tree/nvim-tree.lua' },

  -- File explorer (legacy, lazy-loaded on command)
  { 'scrooloose/nerdtree', cmd = 'NERDTreeToggle' },

  -- Commenting
  { 'scrooloose/nerdcommenter' },
  { 'tpope/vim-commentary' },

  -- Shell sugar
  { 'tpope/vim-eunuch' },

  -- Snippets
  { 'SirVer/ultisnips' },

  -- Git
  { 'airblade/vim-gitgutter' },
  { 'mhinz/vim-signify' },
  { 'itchyny/vim-gitbranch' },
  { 'APZelos/blamer.nvim', commit = 'fed2139ccc931c5991d5673233004025a61c1fc8' },

  -- Editing helpers
  { 'cohama/lexima.vim' },
  { 'mbbill/undotree' },
  { 'majutsushi/tagbar' },
  { 'haya14busa/incsearch.vim' },
  { 'haya14busa/incsearch-fuzzy.vim' },

  -- Linting (general; Python is handled by ruff+basedpyright LSP)
  { 'neomake/neomake' },

  -- LSP
  { 'neovim/nvim-lspconfig' },

  -- Filetype support
  { 'mechatroner/rainbow_csv' },
  { 'NoahTheDuke/vim-just' },

  -- Markdown preview — uses the plugin's own install routine
  {
    'iamcco/markdown-preview.nvim',
    build = function() vim.fn['mkdp#util#install']() end,
    ft = { 'markdown' },
  },

  -- LLM helper
  { 'ggml-org/llama.vim' },

  -- Custom
  { 'NISH1001/join-lines' },
}

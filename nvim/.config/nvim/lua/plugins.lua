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
  { 'ryanoasis/vim-devicons' },
  { 'nvim-tree/nvim-web-devicons' },
  { 'nvim-tree/nvim-tree.lua' },

  -- Indent guides (tree-sitter aware; replaces Yggdroot/indentLine, which
  -- used conceallevel=2 and visually dimmed/hid parts of Python strings).
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('ibl').setup({
        indent = { char = '│' },
        scope = {
          enabled = true,        -- highlights the scope your cursor is in
          show_start = false,    -- no underline at scope start (noisy)
          show_end = false,
        },
        exclude = {
          filetypes = {
            'help', 'alpha', 'dashboard', 'neo-tree', 'Trouble',
            'lazy', 'mason', 'notify', 'toggleterm', 'lazyterm',
          },
        },
      })
    end,
  },

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

  -- ── Tree-sitter (semantic syntax highlighting + smart text objects) ──────
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',       -- stable API; `main` branch is the 2025 rewrite, still settling
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-context',
      'HiPhish/rainbow-delimiters.nvim',
    },
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'python', 'lua', 'vim', 'vimdoc', 'query',
          'bash', 'yaml', 'toml', 'json', 'jsonc',
          'markdown', 'markdown_inline',
          'javascript', 'typescript', 'tsx', 'html', 'css',
          'go', 'rust', 'c', 'cpp',
          'dockerfile', 'gitcommit', 'gitignore', 'diff', 'regex',
        },
        auto_install = true,
        sync_install = false,
        highlight = {
          enable = true,
          -- Keep vim's regex syntax off — tree-sitter replaces it. Leaving
          -- both on can cause double-highlighting and perf hits.
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          -- `gnn` starts; then `grn`/`grc` grow, `grm` shrinks. Chosen to avoid
          -- <C-Space> (used by keymappings.vim for spell toggle).
          keymaps = {
            init_selection    = 'gnn',
            node_incremental  = 'grn',
            scope_incremental = 'grc',
            node_decremental  = 'grm',
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',  -- around function
              ['if'] = '@function.inner',  -- inside function
              ['ac'] = '@class.outer',     -- around class
              ['ic'] = '@class.inner',     -- inside class
              ['aa'] = '@parameter.outer', -- around arg
              ['ia'] = '@parameter.inner', -- inside arg
              ['al'] = '@loop.outer',
              ['il'] = '@loop.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer' },
            goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer' },
          },
        },
      })

      -- Context: sticky function/class header at top of buffer while scrolling
      require('treesitter-context').setup({
        max_lines = 3,
        trim_scope = 'outer',
        mode = 'cursor',
      })

      -- Rainbow brackets — colorscheme-aware (tokyonight supports it)
      -- Enabled globally by just being loaded; no setup call needed.
    end,
  },

  -- ── Colorschemes ─────────────────────────────────────────────────────────
  -- All five are lazy = false so they're immediately available via
  -- `:colorscheme <name>`. Once you pick a favorite, set it in init.lua
  -- (e.g. `vim.cmd.colorscheme('tokyonight-night')`) and optionally mark the
  -- others `lazy = true` or remove them.
  { 'folke/tokyonight.nvim', priority = 1000 },
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
  { 'rebelot/kanagawa.nvim', priority = 1000 },
  { 'rose-pine/neovim', name = 'rose-pine', priority = 1000 },
  { 'sainnhe/gruvbox-material', priority = 1000 },
}

" nvim-tree configuration

lua << EOF
-- Disable netrw (built-in file explorer)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Setup nvim-tree
require("nvim-tree").setup({
  -- Sorting
  sort = {
    sorter = "case_sensitive",
  },
  -- View settings
  view = {
    width = 30,
  },
  -- Renderer settings
  renderer = {
    group_empty = true,
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
    },
  },
  -- Filters
  filters = {
    dotfiles = false,  -- Show hidden files
  },
  -- Git integration
  git = {
    enable = true,
    ignore = false,
  },
})
EOF

" Keybindings
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>e :NvimTreeFocus<CR>

" Dashboard-nvim configuration

lua << EOF
require('dashboard').setup {
  theme = 'doom',
  config = {
    header = {
      '',
      '',
      '██████╗  █████╗ ██████╗  █████╗ ██████╗  ██████╗ ██╗  ██╗',
      '██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔═══██╗╚██╗██╔╝',
      '██████╔╝███████║██████╔╝███████║██║  ██║██║   ██║ ╚███╔╝ ',
      '██╔═══╝ ██╔══██║██╔══██╗██╔══██║██║  ██║██║   ██║ ██╔██╗ ',
      '██║     ██║  ██║██║  ██║██║  ██║██████╔╝╚██████╔╝██╔╝ ██╗',
      '╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝',
      '',
      '',
    },
    center = {
      {
        icon = '  ',
        icon_hl = 'Title',
        desc = 'Find File           ',
        desc_hl = 'String',
        key = 'f',
        key_hl = 'Number',
        action = 'CtrlP',
      },
      {
        icon = '  ',
        icon_hl = 'Title',
        desc = 'Recent Files        ',
        desc_hl = 'String',
        key = 'r',
        key_hl = 'Number',
        action = 'CtrlPMRU',
      },
      {
        icon = '  ',
        icon_hl = 'Title',
        desc = 'File Browser        ',
        desc_hl = 'String',
        key = 'e',
        key_hl = 'Number',
        action = 'NERDTreeToggle',
      },
      {
        icon = '  ',
        icon_hl = 'Title',
        desc = 'Quit Neovim         ',
        desc_hl = 'String',
        key = 'q',
        key_hl = 'Number',
        action = 'quit',
      },
    },
    footer = {},
  },
}
EOF

" Disable folding for dashboard
autocmd FileType dashboard setlocal nofoldenable

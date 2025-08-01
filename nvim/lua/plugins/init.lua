-- Plugin configuration using lazy.nvim
return require('lazy').setup({
  -- Autocomplete and related plugins
  {
    'alvan/vim-closetag',
    ft = {'html', 'xml', 'jsx', 'tsx', 'vue'}
  },
  'jiangmiao/auto-pairs',

  -- Language utilities
  {
    'heavenshell/vim-jsdoc',
    ft = {'javascript', 'typescript'},
    build = 'make install'
  },
  {
    'jparise/vim-graphql',
    ft = {'javascript', 'typescript', 'graphql'}
  },
  {
    'prettier/vim-prettier',
    build = 'yarn install --frozen-lockfile --production',
    ft = {'javascript', 'typescript', 'css', 'scss', 'json', 'graphql', 'markdown', 'vue', 'html'}
  },

  -- Linting
  {
    'dense-analysis/ale',
    config = function()
      -- ALE configuration can be added here
    end
  },

  -- Movement and text manipulation
  'bronson/vim-trailing-whitespace',
  {
    'easymotion/vim-easymotion',
    dependencies = {
      'haya14busa/incsearch.vim',
      'haya14busa/incsearch-fuzzy.vim'
    }
  },
  'junegunn/vim-easy-align',
  'michaeljsmith/vim-indent-object',
  'tpope/vim-surround',
  'wellle/targets.vim',

  -- Prose
  'reedes/vim-lexical',
  'reedes/vim-wordy',

  -- Syntax highlighting
  'sheerun/vim-polyglot',
  'tasn/vim-tsx',

  -- User interface
  'airblade/vim-gitgutter',
  {
    'ap/vim-css-color',
    ft = {'css', 'scss', 'sass', 'less', 'stylus', 'html', 'xhtml', 'jsx', 'tsx', 'vue'},
    config = function()
      vim.g.css_color_mode = 'background'
    end
  },
  'flazz/vim-colorschemes',
  'majutsushi/tagbar',
  'mhinz/vim-startify',
  {
    'vim-airline/vim-airline',
    dependencies = {
      'vim-airline/vim-airline-themes'
    }
  },
  'wellle/visual-split.vim',

  -- Utilities
  'christoomey/vim-tmux-navigator',
  'editorconfig/editorconfig-vim',
  'gisphm/vim-gitignore',
  {
    'ibhagwan/fzf-lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- optional for icon support
    },
    config = function()
      require('fzf-lua').setup({
        -- Performance optimizations
        winopts = {
          height = 0.40,
          width = 0.95,
          row = 0.95,
          preview = {
            default = 'bat',
            vertical = 'down:50%',
            horizontal = 'right:50%',
          }
        },
        files = {
          prompt = 'Files> ',
          multiprocess = true,  -- enable for performance
          git_icons = true,
          file_icons = true,
          color_icons = true,
          find_opts = [[-type f -not -path '*/\.git/*' -not -path '*/node_modules/*' -printf '%P\n']],
          rg_opts = "--color=never --files --hidden --follow -g '!.git' -g '!node_modules'",
          fd_opts = "--color=never --type f --hidden --follow --exclude .git --exclude node_modules",
        },
        grep = {
          multiprocess = true,  -- enable for performance
          prompt = 'Grep> ',
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -g '!.git' -g '!node_modules'",
        },
        keymap = {
          fzf = {
            ['ctrl-s'] = 'toggle+down',
            ['ctrl-a'] = 'toggle-all',
            ['ctrl-d'] = 'half-page-down',
            ['ctrl-u'] = 'half-page-up',
          },
          builtin = {
            ['<C-s>'] = 'actions.file_split',
            ['<C-v>'] = 'actions.file_vsplit',
            ['<C-t>'] = 'actions.file_tabedit',
          }
        }
      })
    end
  },
  'tpope/vim-commentary',
  'tpope/vim-repeat',
  'vim-scripts/ansiesc.vim',

  -- Special plugins (load last)
  {
    'ryanoasis/vim-devicons',
    lazy = false,
    priority = 10
  }
}, {
  -- Lazy.nvim configuration options
  install = {
    colorscheme = { "minimalist" }
  },
  checker = {
    enabled = true,
    notify = false
  },
  change_detection = {
    notify = false
  }
})
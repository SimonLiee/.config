-- ┌─────────────────────────┐
-- │ Plugins outside of MINI │
-- └─────────────────────────┘
--
-- This file contains installation and configuration of plugins outside of MINI.
-- They significantly improve user experience in a way not yet possible with MINI.
-- These are mostly plugins that provide programming language specific behavior.
--
-- Use this file to install and configure other such plugins.

-- Helper Functions ================================================================
-- Make concise helpers for installing/adding plugins in two stages.
-- Add some plugins now if Neovim is started like `nvim -- some-file` because
-- they are needed during startup to work correctly.
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local now_if_args = vim.fn.argc(-1) > 0 and now or later

-- Tree-sitter ================================================================
now(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    -- Use `main` branch since `master` branch is frozen, yet still default
    checkout = 'main',
    -- Update tree-sitter parser after plugin is updated
    hooks = {
      post_checkout = function() vim.cmd('TSUpdate') end,
    },
  })
  add({
    source = 'nvim-treesitter/nvim-treesitter-textobjects',
    -- Same logic as for 'nvim-treesitter'
    checkout = 'main',
  })

  -- Ensure installed parsers for listed languages. Add to `languages`
  -- array languages which you want to have installed. To see available languages:
  --   https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
  local languages = {
    'lua',
    'vimdoc',
    'typescript',
    'tsx',
    'javascript',
    'json',
    'html',
    'css',
    'markdown',
    'go',
    'gomod',
    'gowork',
    'gosum',
  }

  local isnt_installed = function(lang)
    return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0
  end
  local to_install = vim.tbl_filter(isnt_installed, languages)
  if #to_install > 0 then require('nvim-treesitter').install(to_install) end

  -- Ensure tree-sitter enabled after opening a file for target language
  local filetypes = {}
  for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end
  local ts_start = function(ev) vim.treesitter.start(ev.buf) end
  _G.Config.new_autocmd('FileType', filetypes, ts_start, 'Start tree-sitter')
end)

-- Language servers ===========================================================

now_if_args(function()
  add('neovim/nvim-lspconfig')

  vim.lsp.enable({
    'ts_ls',
    'lua_ls',
    'gopls',
  })
end)

-- Formatting =================================================================

-- Programs dedicated to text formatting (a.k.a. formatters) are very useful.
-- Neovim has built-in tools for text formatting (see `:h gq` and `:h 'formatprg'`).
-- They can be used to configure external programs, but it might become tedious.
--
-- The 'stevearc/conform.nvim' plugin is a good and maintained solution for easier
-- formatting setup.
later(function()
  add('stevearc/conform.nvim')

  -- See also:
  -- - `:h Conform`
  -- - `:h conform-options`
  -- - `:h conform-formatters`
  require('conform').setup({
    -- Map of filetype to formatters
    -- Make sure that necessary CLI tool is available
    formatters_by_ft = { lua = { 'stylua' } },
    format_on_save = {
      -- I recommend these options. See :help conform.format for details.
      lsp_format = 'fallback',
      timeout_ms = 500,
    },
  })
  _G.Config.new_autocmd('BufLeave', nil, function()
    require('conform').format({ lsp_fallback = true })
    vim.cmd('silent! write')
  end, 'Save on buffer leave')
end)

-- Snippets ===================================================================

-- Although 'mini.snippets' provides functionality to manage snippet files, it
-- deliberately doesn't come with those.
--
-- The 'rafamadriz/friendly-snippets' is currently the largest collection of
-- snippet files. They are organized in 'snippets/' directory (mostly) per language.
-- 'mini.snippets' is designed to work with it as seamlessly as possible.
-- See `:h MiniSnippets.gen_loader.from_lang()`.
later(function() add('rafamadriz/friendly-snippets') end)

now(function()
  add({ source = 'catppuccin/nvim', name = 'catppuccin' })
  vim.cmd('colorscheme catppuccin-mocha')
end)

-- Autoclose html and tsx tags
later(function()
  add('windwp/nvim-ts-autotag')
  require('nvim-ts-autotag').setup()
end)

later(function()
  add('windwp/nvim-autopairs')
  require('nvim-autopairs').setup({
    ignored_next_char = '[^%s\n]', -- will ignore alphanumeric and `.` symbol
  })
end)

-- Nvim-tmux-navigation: Seamless navigation between tmux and neovim
later(function()
  add('alexghergh/nvim-tmux-navigation')
  require('nvim-tmux-navigation').setup({
    keybindings = {
      left = '<C-h>',
      down = '<C-j>',
      up = '<C-k>',
      right = '<C-l>',
      last_active = '<C-\\>',
      next = '<C-Space>',
    },
  })
end)

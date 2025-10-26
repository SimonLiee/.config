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
now_if_args(function()
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
  })
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

-- Honorable mentions =========================================================

-- 'mason-org/mason.nvim' (a.k.a. "Mason") is a great tool (package manager) for
-- installing external language servers, formatters, and linters. It provides
-- a unified interface for installing, updating, and deleting such programs.
--
-- The caveat is that these programs will be set up to be mostly used inside Neovim.
-- If you need them to work elsewhere, consider using other package managers.
--
-- You can use it like so:
-- later(function()
--   add('mason-org/mason.nvim')
--   require('mason').setup()
-- end)

add({ source = 'catppuccin/nvim', name = 'catppuccin' })
now(function() vim.cmd('colorscheme catppuccin-mocha') end)

-- Autoclose html and tsx tags
later(function()
  add('windwp/nvim-ts-autotag')
  require('nvim-ts-autotag').setup()
end)

-- Auto create, read and save session for cwd and git branch
now(function()
  add('rmagatti/auto-session')
  require('auto-session').setup({
    auto_restore = true,
    auto_save = true,
    auto_create = function()
      -- Ask user to save session if not currently in one
      local session = require('auto-session.lib').current_session_name()
      if session and session ~= '' then return true end

      local choice =
        vim.fn.confirm('Create a new session for this project?', '&Yes\n&No', 1)
      return choice == 1
    end,
  })
end)

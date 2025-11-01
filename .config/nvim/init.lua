vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Save undo history
vim.o.undofile = true

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false
vim.o.number = true
vim.o.mouse = 'a'
vim.o.showmode = false

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

vim.o.confirm = true
vim.o.title = true
vim.o.titlestring = '%{expand("%:h")}'

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  -- 'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.
  --

  -- Alternatively, use `config = function() ... end` for full control over the configuration.
  -- If you prefer to call `setup` explicitly, use:
  --    {
  --        'lewis6991/gitsigns.nvim',
  --        config = function()
  --            require('gitsigns').setup({
  --                -- Your gitsigns configuration here
  --            })
  --        end,
  --    }
  --
  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`.
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '│' },
        change = { text = '│' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '[g', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', ']g', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>gcu', require('gitsigns').reset_hunk)
        vim.keymap.set('n', '<leader>gci', require('gitsigns').preview_hunk)
        vim.keymap.set('n', '<leader>gm', function()
          require('gitsigns').blame_line { full = true }
        end)
        vim.keymap.set('n', '<leader>gbl', require('gitsigns').blame_line)
        vim.keymap.set('n', '<leader>gi', require('gitsigns').toggle_current_line_blame)
      end,
    },
  },

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `opts` key (recommended), the configuration runs
  -- after the plugin has been loaded as `require(MODULE).setup(opts)`.

  -- { -- Useful plugin to show you pending keybinds.
  --   'folke/which-key.nvim',
  --   event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  --   opts = {
  --     -- delay between pressing a key and opening which-key (milliseconds)
  --     -- this setting is independent of vim.o.timeoutlen
  --     delay = 0,
  --     icons = {
  --       -- set icon mappings to true if you have a Nerd Font
  --       mappings = vim.g.have_nerd_font,
  --       -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
  --       -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
  --         Up = '<Up> ',
  --         Down = '<Down> ',
  --         Left = '<Left> ',
  --         Right = '<Right> ',
  --         C = '<C-…> ',
  --         M = '<M-…> ',
  --         D = '<D-…> ',
  --         S = '<S-…> ',
  --         CR = '<CR> ',
  --         Esc = '<Esc> ',
  --         ScrollWheelDown = '<ScrollWheelDown> ',
  --         ScrollWheelUp = '<ScrollWheelUp> ',
  --         NL = '<NL> ',
  --         BS = '<BS> ',
  --         Space = '<Space> ',
  --         Tab = '<Tab> ',
  --         F1 = '<F1>',
  --         F2 = '<F2>',
  --         F3 = '<F3>',
  --         F4 = '<F4>',
  --         F5 = '<F5>',
  --         F6 = '<F6>',
  --         F7 = '<F7>',
  --         F8 = '<F8>',
  --         F9 = '<F9>',
  --         F10 = '<F10>',
  --         F11 = '<F11>',
  --         F12 = '<F12>',
  --       },
  --     },
  --
  --     -- Document existing key chains
  --     spec = {
  --       { '<leader>s', group = '[S]earch' },
  --       { '<leader>t', group = '[T]oggle' },
  --       { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
  --     },
  --   },
  -- },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/vicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      -- [[ Configure Telescope ]]
      require('telescope').setup {
        pickers = {
          git_files = {
            theme = 'dropdown',
          },
          oldfiles = {
            theme = 'dropdown',
          },
        },
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
              ['<esc>'] = require('telescope.actions').close,
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>ff', builtin.git_files, { desc = 'Search [G]it [F]iles' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- Helper function for mapping LSP-related keys
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- NOTE: 'grn' for rename - using your <leader>re from old config instead
          map('<leader>re', vim.lsp.buf.rename, '[R]e[n]ame')

          -- NOTE: 'gra' for code action - using your <leader>ac from old config instead
          map('<leader>ac', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

          -- NOTE: 'grr' for references - using your <leader>gu from old config instead
          map('<leader>gu', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- NOTE: 'gri' for implementation - using your gI mapping from old config
          map('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')

          -- Map for definition - using your original gd mapping
          map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')

          -- NOTE: 'grD' for declaration - keeping your 'gD' from old config
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- NOTE: 'gO' for document symbols - using your <leader>ds from old config
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- NOTE: 'gW' for workspace symbols - commented out as you didn't have an equivalent
          -- map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

          -- NOTE: 'grt' for type definition - using your <leader>D from old config
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- Signature help - keeping your original C-k mapping
          map('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

          -- Workspace folder management
          map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
          map('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
          map('<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, '[W]orkspace [L]ist Folders')

          -- Format command - create Format command for LSP buffer
          vim.api.nvim_buf_create_user_command(event.buf, 'Format', function(_)
            vim.lsp.buf.format()
          end, { desc = 'Format current buffer with LSP' })

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- NOTE: Added support for inlay hints toggle if supported by language server
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        -- gopls = {},
        pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        ts_ls = {},
        --

        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>F',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        json = { 'prettierd', 'prettier', stop_after_first = true },
      },
      formatters = {
        prettierd = {
          -- Force using global config
          prepend_args = { '--config', vim.fn.expand '~/.prettierrc.json' },
        },
        prettier = {
          -- Force using global config
          prepend_args = { '--config', vim.fn.expand '~/.prettierrc.json' },
        },
      },
    },
  },

  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'super-tab',

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'lua' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
  {
    'akinsho/toggleterm.nvim',
    branch = 'main',
    opts = {
      open_mapping = [[<a-`>]],
    },
  },
  { -- Catppuccin theme
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        integrations = {
          cmp = true,
          semantic_tokens = true,
          native_lsp = {
            enabled = true,
            underlines = {
              errors = { 'undercurl' },
              hints = { 'undercurl' },
              warnings = { 'undercurl' },
              information = { 'undercurl' },
            },
          },
          sandwich = true,
          gitsigns = true,
          telescope = true,
          dap = {
            enabled = true,
            enable_ui = true,
          },
        },
      }
      -- Note: This will replace TokyoNight theme, comment this line if you want to keep TokyoNight
      vim.cmd.colorscheme 'catppuccin-latte'
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- File explorer that uses buffer editing
    'stevearc/oil.nvim',
    opts = {
      delete_to_trash = true,
      columns = {
        'icon',
      },
      keymaps = {
        ['yy'] = 'actions.copy_entry_path',
      },
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  { -- Remembers cursor position
    'farmergreg/vim-lastplace',
  },
  { -- Session management
    'rmagatti/auto-session',
    dependencies = {
      'rmagatti/session-lens', -- telescope integration
    },
    opts = {
      auto_session_enable_last_session = true,
    },
  },
  {
    'sindrets/diffview.nvim',
  },
  {
    'olimorris/codecompanion.nvim',
    opts = {
      adapters = {
        http = {
          gemini = function()
            return require('codecompanion.adapters').extend('gemini', {
              env = {
                api_key = 'AIzaSyDwL-bmpuKVSshQ3d7AIT8KHQAHu0UiXjc', -- Make sure to set this environment variable
                model = 'gemini-2.5-flash-001', -- The free Gemini 2.5 Flash model
              },
            })
          end,
        },
      },
      strategies = {
        chat = {
          adapter = 'gemini',
          model = 'gemini-2.5-flash-001',
        },
        inline = {
          adapter = 'gemini',
          model = 'gemini-2.5-flash-001',
        },
      },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },
  {
    'tpope/vim-fugitive',
  },
  { -- Repeat plugin actions
    'tpope/vim-repeat',
  },
  {
    'tpope/vim-sleuth',
  },
  { -- Unix commands in Vim
    'tpope/vim-eunuch',
  },
  { -- Complementary pairs of mappings
    'tpope/vim-unimpaired',
  },
  { -- Exchange text regions
    'tommcdo/vim-exchange',
  },
  {
    'vim-scripts/ReplaceWithRegister',
    config = function()
      -- Disable default mappings
      vim.g.ReplaceWithRegisterOperatorMappings = 0
      -- Set up leader-based mappings because of lsp default mapping
      vim.keymap.set('n', '<Leader>gr', '<Plug>ReplaceWithRegisterOperator', { noremap = false })
      vim.keymap.set('n', '<Leader>grr', '<Plug>ReplaceWithRegisterLine', { noremap = false })
      vim.keymap.set('x', '<Leader>gr', '<Plug>ReplaceWithRegisterVisual', { noremap = false })
    end,
  },
  {
    'psliwka/vim-smoothie', -- smooth scrolling
    init = function()
      vim.g.smoothie_no_default_mappings = 1
      vim.keymap.set('n', '<down>', '<Plug>(SmoothieDownwards)')
      vim.keymap.set('n', '<up>', '<Plug>(SmoothieUpwards)')
    end,
  },
  { -- Improved search
    'haya14busa/is.vim',
  },
  { -- Auto-save files.
    '907th/vim-auto-save',
    init = function()
      vim.g.auto_save = 1
      vim.g.auto_save_silent = 1
      vim.g.auto_save_events = { 'BufLeave' }
      vim.o.updatetime = 1000
    end,
  },
  {
    'mhinz/vim-grepper',
    init = function()
      vim.g.grepper = {
        tools = { 'rg', 'git' },
        rg = {
          grepprg = 'rg -H --smart-case --no-heading --vimgrep' .. (vim.fn.has 'win32' == 1 and ' $* .' or ''),
          grepformat = '%f:%l:%c:%m,%f',
          escape = '\\^$.*+?()[]{}|',
        },
        highlight = 1,
      }

      -- Set up the keymaps
      vim.keymap.set('n', 'gs', '<plug>(GrepperOperator)', {})
      vim.keymap.set('x', 'gs', '<plug>(GrepperOperator)', {})
      -- vim.keymap.set('n', '<leader>//', ':Grepper<cr>', {})
    end,
  },
  { -- Sudo editing
    'lambdalisue/suda.vim',
  },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup {
        options = {
          theme = 'catppuccin-latte',
          icons_enabled = true,
          component_separators = '|',
          section_separators = '',
          globalstatus = true,
        },
        sections = {
          -- lualine_a = { require('auto-session.lib').current_session_name },
          lualine_b = {}, -- shorter mode
          lualine_c = { 'diagnostics' },
          lualine_x = { 'diff' },
          lualine_y = { 'progress' },
          lualine_z = { 'branch' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        winbar = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {},
          lualine_x = { '%{expand("%:h")}' },
          lualine_y = { 'filename' },
          lualine_z = {},
        },
        inactive_winbar = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { 'filename' },
        },
        extensions = { 'fugitive', 'toggleterm', 'man', 'lazy' },
      }
    end,
  },
  {
    'machakann/vim-sandwich',
    init = function()
      vim.g.operator_sandwich_no_default_key_mappings = 1
    end,
  },
  {
    'windwp/nvim-autopairs', -- autocloses parens
    event = 'InsertEnter',
    config = true,
  },
  { -- QuickFix improvements
    'romainl/vim-qf',
    init = function()
      vim.g.qf_mapping_ack_style = 1
      vim.g.qf_max_height = 14
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },

  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- { import = 'custom.plugins' },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

vim.keymap.set('n', '-', require('oil').open, { desc = 'Open parent directory' })
vim.keymap.set('n', '<leader>wf', '<Plug>(qf_qf_toggle)')
vim.cmd [[
  xnoremap <silent> ie gg0oG$
  onoremap <silent> ie :<C-U>execute "normal! m`"<Bar>keepjumps normal! ggVG<CR>
  xnoremap <silent> ii <Esc>^vg_
  onoremap <silent> ii :<C-U>normal! ^vg_<CR>
]]

vim.keymap.set('n', '<leader><tab>', '<c-^>', { desc = 'Switch to last buffer' })
vim.keymap.set('n', '<leader><leader>', '<c-w><c-w>', { desc = 'Switch between windows' })
vim.keymap.set('n', '<leader>gfl', '<cmd>DiffviewFileHistory %<cr>', { desc = 'Git file history' })

-- Vim-fugitive keymaps
vim.cmd [[
  function! ToggleGStatus()
      if buflisted(bufname('.git/index'))
          gq
      else
          Git
      endif
  endfunction
  command! ToggleGStatus :call ToggleGStatus()
]]

vim.keymap.set('n', '<Leader>gs', ':ToggleGStatus<CR>', { desc = 'Toggle Git status' })
vim.keymap.set('n', '<Leader>gl', ':Git --paginate llg<CR>', { desc = 'Git log' })
vim.keymap.set('n', '<Leader>gL', ':DiffviewFileHistory<CR>', { desc = 'Git file history (all files)' })

-- Window management
vim.keymap.set('n', '<leader>wv', ':vsplit<CR>', { desc = 'Vertical split' })
vim.keymap.set('n', '<leader>ws', ':split<CR>', { desc = 'Horizontal split' })
vim.keymap.set('n', '<leader>wq', ':close<CR>', { desc = 'Close window' })
vim.keymap.set('n', '<leader>wc', ':close<CR>', { desc = 'Close window' })
vim.keymap.set('n', '<leader>wo', ':only<CR>', { desc = 'Close all other windows' })
vim.keymap.set('n', '<leader>ww', '<c-w><c-w>', { desc = 'next window' })

-- Tab control
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = 'New tab' })
vim.keymap.set('n', '<leader>to', ':tabonly<CR>', { desc = 'Close other tabs' })
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { desc = 'Close tab' })

-- Tab navigation
vim.keymap.set('n', ']t', ':tabn<CR>', { desc = 'Next tab' })
vim.keymap.set('n', '[t', ':tabp<CR>', { desc = 'Previous tab' })
vim.keymap.set('n', '[T', ':tabfirst<CR>', { desc = 'First tab' })
vim.keymap.set('n', ']T', ':tablast<CR>', { desc = 'Last tab' })

-- Save keymaps
vim.keymap.set('i', '<M-s>', ':update<CR><ESC>', { desc = 'Save file' })
vim.keymap.set('n', '<M-s>', ':update<cr>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>s', ':update<cr>', { desc = 'Save file' })

-- Backspace to delete word in normal mode
vim.keymap.set('n', '<BS>', 'ciw', { desc = 'Delete word' })

-- NOTE note needed use native [d
-- vim.keymap.set('n', '[e', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
-- vim.keymap.set('n', ']e', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })

-- Close quickfix/location window
vim.keymap.set('n', '<leader>qq', ':cclose<bar>lclose<cr>', { desc = 'Close quickfix/location window' })
-- Yank till end of line
vim.keymap.set('n', 'Y', 'y$', { desc = 'Yank to end of line' })

vim.cmd [[
  " Auto-clean fugitive buffers
  autocmd BufReadPost fugitive://* set bufhidden=delete

  " C to go to commit
  autocmd User fugitive
    \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
    \   nnoremap <buffer> .. :edit %:h<CR> |
    \ endif

  " Auto-resize splits when Vim gets resized
  autocmd VimResized * wincmd =

  " Open help in vertical split
  autocmd FileType help wincmd L

  " Notification after file change
  autocmd FileChangedShellPost *
    \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
]]

vim.cmd "command! DiffHead :execute 'Git difftool -y head~'"

-- QuickFix toggle function
vim.cmd [[
function! ToggleQuickFix()
  if empty(filter(getwininfo(), 'v:val.quickfix'))
    copen
  else
    cclose
  endif
endfunction
]]
vim.cmd 'command! ToggleQuickFix call ToggleQuickFix()'

-- Undo directory setup
vim.cmd [[
  if !isdirectory($HOME . "/.vim/undodir")
      call mkdir($HOME . "/.vim/undodir", "p", 0700)
  endif
]]
vim.o.undofile = true
vim.o.undodir = vim.fn.expand '~/.vim/undodir'

-- Notification after file change
vim.cmd [[
  " Notification after file change
  autocmd FileChangedShellPost *
    \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
]]

-- Load vim-sandwich surround keymaps
vim.cmd [[runtime macros/sandwich/keymap/surround.vim]]

-- change cursor for terminal to blinking line instead of block
vim.opt.guicursor:append 't:ver25-blinkon250-blinkoff250'

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }

  vim.keymap.set('t', '<A-h>', [[<C-\><C-n><Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<A-j>', [[<C-\><C-n><Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<A-k>', [[<C-\><C-n><Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<A-l>', [[<C-\><C-n><Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<A-n>', [[<C-\><C-n><Cmd>TermNew<CR>]], opts)
  vim.keymap.set('t', '<A-q>', [[<C-\><C-n><C-w>]], opts)

  vim.keymap.set('n', '<A-h>', '<Cmd>wincmd h<CR>', opts)
  vim.keymap.set('n', '<A-j>', '<Cmd>wincmd j<CR>', opts)
  vim.keymap.set('n', '<A-k>', '<Cmd>wincmd k<CR>', opts)
  vim.keymap.set('n', '<A-l>', '<Cmd>wincmd l<CR>', opts)
  vim.keymap.set('n', '<A-n>', '<Cmd>TermNew<CR>', opts)
  vim.keymap.set('n', '<A-q>', '<C-w>', opts)
end

vim.api.nvim_create_augroup('MyTermMaps', { clear = true })
vim.api.nvim_create_autocmd('TermOpen', {
  group = 'MyTermMaps',
  pattern = 'term://*',
  callback = function()
    set_terminal_keymaps()
  end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

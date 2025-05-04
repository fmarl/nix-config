{ pkgs, lib, config, nixosConfigurations, ... }:

with lib;

let cfg = config.modules.neovim;

in {
  options.modules.neovim.enable = mkEnableOption "Install and configure neovim";

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      plugins = with pkgs; [
        vimPlugins.vim-airline
        vimPlugins.vim-airline-themes
        vimPlugins.nvim-lspconfig
        vimPlugins.cmp-nvim-lsp
        vimPlugins.nvim-cmp
        vimPlugins.luasnip
        vimPlugins.nvim-tree-lua
        vimPlugins.fzf-lua
      ];
      extraLuaConfig = ''
        -- disable netrw at the very start of your init.lua
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        vim.g.nvim_tree_show_icons = {
          folders = 0,
          files = 0,
          git = 0,
          folder_arrows = 0,
        }

        -- optionally enable 24-bit colour
        vim.opt.termguicolors = true

        -- empty setup using defaults
        require("nvim-tree").setup({
                renderer = {
                        icons = {
        			            show = {
                                        file = false,
                                        folder = false,
                                        folder_arrow = false,
                                },
        		        },
                },
        })

        -- LSP Configuration
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        local lspconfig = require('lspconfig')
        local fzf = require('fzf-lua')

        vim.lsp.enable('clangd')
        vim.lsp.config('clangd', {
          cmd = { 'clangd' }
        })

        vim.lsp.enable('rust_analyzer')
        vim.lsp.config('rust_analyzer', {
          -- Server-specific settings. See `:help lsp-quickstart`
          settings = {
            ['rust-analyzer'] = {},
          },
        })

        luasnip.config.setup {}

        cmp.setup {
           snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert {
            ['<C-Space>'] = cmp.mapping.complete {},
            ['<CR>'] = cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            },
            ['<Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { 'i', 's' }),
          },
          sources = {
            { name = 'nvim_lsp', max_item_count = 5 },
            { name = 'luasnip' },
          },     
        }

        -- Store backups together
        vim.opt.directory = vim.fn.stdpath('config') .. '/backups'

        -- Keep undo history between sessions
        vim.opt.undofile = true
        vim.opt.undodir = vim.fn.stdpath('config') .. '/undo'

        -- Incremental search
        vim.opt.incsearch = true

        -- Autoindent with tab being 4 spaces
        vim.opt.autoindent = true
        vim.opt.tabstop = 4
        vim.opt.expandtab = true

        -- Airline always show numbered listed of buffers
        vim.g['airline#extensions#tabline#enabled'] = 1
        vim.g['airline#extensions#tabline#buffer_nr_show'] = 1

        -- Airline show buttom line always, hide vim mode
        vim.opt.laststatus = 2
        vim.opt.showmode = false
        vim.opt.number = true

        -- Airline remove pause after leaving insert mode
        vim.opt.timeoutlen = 50

        -- Background buffers
        vim.opt.hidden = true

        -- Don't split when opening a new file
        vim.g.ctrlp_open_new_file = 'r'

        -- Theming
        vim.cmd [[
        	syntax enable
        ]]

        vim.g.airline_theme = 'luna'
        vim.g.airline_powerline_fonts = 1
        vim.opt.cursorline = true

        vim.opt.colorcolumn = '100'
        vim.api.nvim_set_option("clipboard","unnamed") 

        vim.keymap.set('n', 'f', fzf.lsp_document_symbols, { noremap = true, silent = true })
        vim.keymap.set('n', 'b', fzf.buffers, { noremap = true, silent = true })
        vim.keymap.set('n', '<leader>f', fzf.files, { noremap = true, silent = true })
      '';
    };
  };
}

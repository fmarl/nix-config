{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.modules.neovim;

in
{
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
        (vimPlugins.nvim-treesitter.withPlugins (p: [
          p.c
          p.go
          p.rust
        ]))
        vimPlugins.go-nvim
        vimPlugins.sonokai
      ];
      extraLuaConfig = ''
        -- Disable netrw at the very start
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

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

        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        local lspconfig = require('lspconfig')
        local fzf = require('fzf-lua')

        -- NvimTree
        vim.g.nvim_tree_show_icons = {
          folders = 0,
          files = 0,
          git = 0,
          folder_arrows = 0,
        }

        -- Theme
        vim.cmd 'colorscheme sonokai'
        vim.opt.termguicolors = true

        -- Treesitter
        require('nvim-treesitter.configs').setup {}

        -- GO
        vim.lsp.enable('gopls')
        require('go').setup()
        local format_sync_group = vim.api.nvim_create_augroup("GoFormat", {})
        vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.go",
                callback = function()
                        require('go.format').goimports()
                end,
                group = format_sync_group,
        })

        -- C/C++
        vim.lsp.enable('clangd')
        vim.lsp.config('clangd', {
          cmd = { 'clangd' }
        })

        -- Rust
        vim.lsp.enable('rust_analyzer')

        -- Python
        vim.lsp.enable('pyright')

        -- Luasnip
        luasnip.config.setup {}

        -- CMP
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

        -- Autoindent with tab being 2 spaces
        vim.opt.autoindent = true
        vim.opt.softtabstop = 2
        vim.opt.tabstop = 2
        vim.opt.expandtab = true
        vim.opt.shiftwidth = 2

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

        vim.g.airline_theme = 'sonokai'
        vim.g.airline_powerline_fonts = 1
        vim.opt.cursorline = true

        vim.opt.timeoutlen = 100
        vim.opt.ttimeoutlen = 0
        vim.opt.colorcolumn = '100'
        vim.api.nvim_set_option("clipboard","unnamed") 

        -- FZF
        vim.keymap.set('n', 'b', fzf.buffers, { noremap = true, silent = true })
        vim.keymap.set('n', '<leader>f', fzf.files, { noremap = true, silent = true })

        -- LSP
        vim.keymap.set('n', 'f', fzf.lsp_document_symbols, { noremap = true, silent = true })
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { noremap = true, silent = true })

        -- Useful utils
        vim.keymap.set('n', '<leader>sr', [[:%s/<C-r><C-w>//gc<Left><Left><Left>]])

        -- Buffer Navigation
        vim.keymap.set('n', '<leader>c', [[:bd<CR>]])
        vim.keymap.set('n', '<S-TAB>', [[:bp<CR>]])
        vim.keymap.set('n', '<TAB>', [[:bn<CR>]])

        -- Code Navigation
        vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
        vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
        vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true })
        vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true })
      '';
    };
  };
}

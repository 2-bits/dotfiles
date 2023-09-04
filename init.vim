" I believe directories with a . in them now work in windows, so no special
" handling is necessary
let plug_path = '~/.vim/plugged'

if has('nvim')
  let plug_path = stdpath('data') . '/plugged'
endif

call plug#begin(plug_path)

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp/'
Plug 'hrsh7th/cmp-nvim-lsp'      " LSP source for nvim-cmp
Plug 'hrsh7th/cmp-buffer'        " Buffer source for nvim-cmp
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'} " Replace <CurrentMajor> by the latest released major (first number of latest release)

Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf.vim'

" Typing assistants
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'Raimondi/delimitMate'

Plug 'junegunn/goyo.vim'

" Source control plugins
Plug 'tpope/vim-fugitive'

" Airline and its themes.
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'Chiel92/vim-autoformat'
Plug 'rust-lang/rust.vim'

"Somehow, polyglot provides syntax highlighting for F# but not C#.
Plug 'OrangeT/vim-csharp'

" This replaces most of the file type plugins I was pulling in.
" Honestly does it better too.
Plug 'sheerun/vim-polyglot'

" Color schemes
Plug 'chriskempson/base16-vim'
Plug 'nanotech/jellybeans.vim'

Plug 'junegunn/rainbow_parentheses.vim'

call plug#end()

syntax enable

set bs=2
set shiftwidth=4
set tabstop=4     " tab characters (if they exist) look like 4 spaces
set textwidth=0   " disable hard wrapping

set nowrap        " please don't wrap text

set expandtab     " tab key inserts spaces

set ignorecase    " ignore case for search
set smartcase     " ...unless I use a capital letter
set incsearch     " show search matches as I type
set hlsearch      " highlight search matches
set showmatch     " show matching brace

" Make horizontal splits open below and vertical splits open to the right
set splitbelow
set splitright

set number      " show line numbers. That's just generally something I want

set mouse=a     " Enable mouse use.

" commands for when you hold down the shift key for too long. The reason I have
" done only these is that the capitals are not bound to anything else. I
" can't do this with E, for example, because that opens netrw
command! -bang Q q
command! -bang QA qa
command! -bang Qa qa
command! -bang WQ wq
command! -bang Wq wq
command! -bang W w
command! -bang Wa wa
command! -bang WA wa

command FormatJson %!jq .

" TODO: Bind these to something cool? Maybe moving a selection?
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

" delete trailing space at the end of lines in programming files
autocmd! BufWritePre *.vim,*.rs,*.md,*.dsql,*.json,*.sql,*.cs,*.py,*.java,*.c,*.h,*.cpp,*.js,*.scala,*.sc,*.hs,*.lhs %s/\s\+$//e

autocmd! Filetype haskell setlocal ts=2 sw=2
autocmd! Filetype ps1 setlocal ts=2 sw=2
autocmd! Filetype rust setlocal ts=4 sw=4
autocmd! Filetype c setlocal ts=2 sw=2
autocmd! Filetype javascript setlocal ts=2 sw=2
autocmd! Filetype json setlocal ts=2 sw=2 foldmethod=syntax foldlevelstart=99
autocmd! Filetype text setlocal tw=80 cc=81 linebreak wrap spell
autocmd! Filetype markdown setlocal sw=2 ts=2 linebreak wrap spell
autocmd! FileType tsv setlocal list
autocmd! FileType csv setlocal list
autocmd! Filetype xml setlocal ts=2 sw=2
autocmd! Filetype vim setlocal ts=2 sw=2

" spell checking is extremely unhelpful on help text
autocmd! FileType help setlocal nospell

" NeoVim specific settings
if has('nvim')
  " Annoyingly, line numbers show up on Neovim's terminal emulator
  autocmd! TermOpen * setlocal nonumber
endif

" vim-markdown settings

let g:vim_markdown_conceal = 1
let g:vim_markdown_new_list_item_indent = 2

" airline settings

let g:airline#extensions#neomake#enabled = 1
let g:airline#extensions#neomake#error_symbol = 'E:'
let g:airline#extensions#neomake#warning_symbol = 'W:'

" Let airline draw my tabline too, for coolness
let g:airline#extensions#tabline#enabled = 1

" What the hell? Don't clutter my tab line. I can't even see my tabs with these on.
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_splits = 0

" For making your vim look cool and fly or whatever
let g:airline_powerline_fonts = 1

" Christ on a cracker that is annoying
set belloff=all

colorscheme base16-solarflare
set termguicolors

" Options for code completion
set completeopt=menuone,noinsert,noselect

lua <<EOF

-- nvim_lsp object
local nvim_lsp = require'lspconfig'
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
     completion = cmp.config.window.bordered(),
     documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' }, -- For vsnip users.
    { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

 nvim_lsp.hls.setup {
    capabilities = capabilities
 }

 nvim_lsp.rust_analyzer.setup {
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importGranularity = "module",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    },
    capabilities = capabilities
}

nvim_lsp.clangd.setup {
  root_dir = function() return vim.loop.cwd() end,
  capabilities = capabilities
}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)

EOF


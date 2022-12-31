" I believe directories with a . in them now work in windows, so no special
" handling is necessary
let plug_path = '~/.vim/plugged'

if has('nvim')
  let plug_path = stdpath('data') . '/plugged'
endif

call plug#begin(plug_path)

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp/'

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

" When writing a buffer (no delay).
" call neomake#configure#automake('w')
" " When writing a buffer (no delay), and on normal mode changes (after 750ms).
" call neomake#configure#automake('nw', 750)
" " When reading a buffer (after 1s), and when writing (no delay).
" call neomake#configure#automake('rw', 1000)
" " Full config: when writing or reading a buffer, and on changes in insert and
" " normal mode (after 1s; no delay when writing).
" call neomake#configure#automake('nrwi', 500)

" let g:neomake_open_list = 2

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

 -- function to attach completion when setting up lsp
-- local on_attach = function(client)
--  require'completion'.on_attach(client)
-- end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  print(client)

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

  require'completion'.on_attach(client)
end

-- For some reason, this appears to do nothing. I don't really care as its copy pasta but it caused me
-- to waste time debugging so it's gone until I figure out why it was ever needed

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "rust_analyzer", "hls" }
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup { on_attach = on_attach }
end

nvim_lsp.hls.setup({
    on_attach=on_attach,
})

nvim_lsp.rust_analyzer.setup({
    on_attach=on_attach,
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
    }
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

" Neovide, for whatever reason, does not source ginit.vim, which is fine because I don't have one anymore
if exists('g:neovide')
  set guifont=PragmataPro\ Mono\ Liga:h18
end

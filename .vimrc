let mapleader = ' ' " map leader to space

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" Declare the list of plugins.
Plug 'flazz/vim-colorschemes'
Plug 'metakirby5/codi.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug '/usr/local/opt/fzf'
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf.vim'
Plug 'mattn/emmet-vim'
Plug 'airblade/vim-rooter'
" Plug 'vimwiki/vimwiki'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'tpope/vim-unimpaired'
Plug 'lambdalisue/suda.vim' " for editing with sudo in nvim

Plug 'rakr/vim-one' " or other package manager
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.sh'}


Plug 'vim-scripts/ReplaceWithRegister'

Plug 'AndrewRadev/splitjoin.vim'
nmap sj :SplitjoinSplit<cr>
nmap sk :SplitjoinJoin<cr>

Plug 'junegunn/gv.vim'
"" Open git log in new tab
nnoremap <silent> <Leader>gl :GV<CR>

call plug#end()

" markdown
let g:vim_markdown_folding_style_pythonic = 1

" vim wiki 
" let g:vimwiki_map_prefix = '<Leader>e'
" let wiki = {}
" let wiki.path ='~/dropbox/notes/'
" let wiki.syntax ='markdown'
" let wiki.ext ='.md'
" let g:vimwiki_list = [wiki]
" let g:vimwiki_folding='expr'
""""color theme"""""""""

" for getting colors to work source: https://github.com/rakr/vim-one

"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
if (has("nvim"))
"For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
  set termguicolors
endif


" set background=dark " for the dark version
 set background=light " for the light version
 colorscheme one

" prev color scheme
"colorscheme seoul256
"let g:seoul256_background = 233

"""""""""""""""""""
""" coc

" Better display for messages
set cmdheight=2

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes
"
" Show title of window as file name
set title

""""
"status line. stolen from https://github.com/junegunn/dotfiles/blob/master/vimrc
function! s:statusline_expr()
  let mod = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
  let ro  = "%{&readonly ? '[RO] ' : ''}"
  let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
  let fug = "%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
  let sep = ' %= '
  let pos = ' %-12(%l : %c%V%) '
  let pct = ' %P'

  return '[%n] %F %<'.mod.ro.ft.fug.sep.pos.'%*'.pct
endfunction
let &statusline = s:statusline_expr()
"""

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [e <Plug>(coc-diagnostic-prev)
nmap <silent> ]e <Plug>(coc-diagnostic-next)

" navigate chunks of current buffer
nmap [c <Plug>(coc-git-prevchunk)
nmap ]c <Plug>(coc-git-nextchunk)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <leader>h <Plug>(coc-diagnostic-info)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>re <Plug>(coc-rename)
" Remap keys for applying codeAction to the current buffer.
xmap <leader>ac  <Plug>(coc-codeaction-selected)
nmap <leader>ac  <Plug>(coc-codeaction-selected)

" sets up prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile
vmap <leader>cf  <Plug>(coc-format-selected)
map <leader>cf <Plug>(coc-format)

"hide search highlight
nnoremap <leader><esc> :noh<cr>

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Search workspace symbols
nnoremap <silent> <space>cd  :<C-u>CocList -I symbols<cr>

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

nmap <silent> <A-k> <Plug>(coc-range-select)
xmap <silent> <A-k> <Plug>(coc-range-select)
nmap <silent> <A-j> <Plug>(coc-range-select-backward)
xmap <silent> <A-j> <Plug>(coc-range-select-backward)

""""""""""""""'

autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline



"   :Ag  - Start fzf with hidden preview window that can be enabled with "?" key
"   :Ag! - Start fzf in fullscreen and display the preview window above
 command! -bang -nargs=* Ag
   \ call fzf#vim#ag(<q-args>,
   \                 <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'},'up:60%')
   \                         : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'},'right:50%:hidden', '?'),
   \                 <bang>0)



nnoremap <leader>fr :History<cr>
" nnoremap <leader><leader> :GFiles<cr>
" nnoremap <leader>gs :GFiles?<cr>
nnoremap <leader>wv :vsplit<cr>
nnoremap <leader>qq :close<cr>

" update is like save but only runs when file has change so doesn't change
nnoremap <leader>s :update<cr>

" open directory current file
nnoremap <leader>fd :Ex<cr>

"scrolling 
nmap <C-j> 3j3<C-e>
nmap <C-k> 3k3<C-y>

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <leader>fr  :<C-u>CocList mru -A<cr>
nnoremap <silent> <leader>o  :<C-u>CocList outline<cr>
nnoremap <silent> <leader><leader>  :<C-u>CocList files<cr>


" reduce update time for faster gitgutter update
set updatetime=200

" Buffer management
nnoremap <leader>[  :bprevious<CR>
nnoremap <leader>] :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

" Window management
nnoremap <leader>wv :vsplit<CR>
nnoremap <leader>ws  :split<CR>
nnoremap <leader>wq :quit<CR>
nnoremap <leader>ww <c-w><c-w>

nnoremap <space> za
let g:highlightedyank_highlight_duration = 200

" Customize fzf colors to match your color scheme

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }



" always keep gutter open
autocmd BufRead,BufNewFile * setlocal signcolumn=yes

syntax enable
set number
set wildmenu
set wildmode=longest:full,full
set timeoutlen=1000 ttimeoutlen=0 "elimentates delay when getting in and out of cmd
set incsearch              " Highlight Search
set autoindent             " Indent according to previous line.
set expandtab              " Use spaces instead of tabs.
set softtabstop =2         " Tab key indents by 4 spaces.
set shiftwidth  =2         " >> indents by 4 spaces.
set shiftround             " >> indents to next multiple of 'shiftwidth'.

set backspace   =indent,eol,start  " Make backspace work as you would expect.
set hidden                 " Switch between buffers without having to save first.
set laststatus  =2         " Always show statusline.
set display     =lastline  " Show as much as possible of the last line.
set cursorline             " Highlight cursor line
set showmode               " Show current mode in command-line.
set showcmd                " Show already typed keys when more are expected.
set ignorecase              " All searches will be case insensative
set smartcase              " Ignore case in searching unless uppercase letters are used
set ttyfast                " Faster redrawing.
set lazyredraw             " Only redraw when necessary.

filetype plugin indent on  " for vimwiki
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent

" Maintain undo history between sessions
if !isdirectory($HOME . "/.vim/undodir")
    call mkdir($HOME . "/.vim/undodir", "p", 0700)
endif
set undofile
set undodir=~/.vim/undodir

" swap files
if !isdirectory($HOME . "/.vim/swap")
    call mkdir($HOME . "/.vim/swap", "p", 0700)
endif
set directory   =~/.vim/swap
set updatecount =100
set shortmess=A "disables annoying swap warnings

if exists('&inccommand')
  set inccommand=split
endif

" shows insert cursor in iTerm2
" let &t_SI = "\<Esc>]50;CursorShape=1\x7"
" let &t_SR = "\<Esc>]50;CursorShape=2\x7"
" let &t_EI = "\<Esc>]50;CursorShape=0\x7"
let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[4 q" "SR = REPLACE mode
let &t_EI.="\e[1 q" "EI = NORMAL mode (ELSE)

" Maintain undo history between sessions
set clipboard=unnamed

" Auto reload changed files 
" (source https://unix.stackexchange.com/a/383044 )
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" Notification after file change
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Silver searcher - Ag
if executable('ag')
  let &grepprg = 'ag --nogroup --nocolor --column'
else
  let &grepprg = 'grep -rn $* *'
endif
command! -nargs=1 -bar Grep execute 'silent! grep! <q-args>' | redraw! | copen

nnoremap <leader>// :Grep 

" write with sudo
command! Sudow :execute 'w suda://%' 

" autosave
au BufLeave * silent! wall

" Close quickfix/location window
nnoremap <leader>qq :cclose<bar>lclose<cr>

"" Open new split panes to right and bottom, which feels more natural than Vim’s default:
set splitright
set splitbelow

"" Open Gstatus in new tab
nnoremap <silent> <Leader>gs :tab G<CR>
"" Close tab
nnoremap <Leader>tq :tabclose<CR>


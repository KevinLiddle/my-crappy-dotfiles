" some gems taken from https://bitbucket.org/sjl/dotfiles

set nocompatible
syntax on

filetype off
call pathogen#infect()
filetype plugin indent on

set modelines=0
set encoding=utf-8
set autoindent
set nosmartindent
set history=10000
set number
set background=dark
set hidden
set backspace=indent,eol,start
set textwidth=0

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

nmap , \

" search
set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
noremap <silent> <leader><space> :noh<cr>:call clearmatches()<cr>
nnoremap <leader>a :Ack<space>

set cursorline
set wrap
set wrapmargin=350
set noswapfile
set bs=2

if &t_Co == 256
  colorscheme Tomorrow-Night
  set t_ut=
endif

" highlight trailing whitespace
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd BufRead,InsertLeave * match ExtraWhitespace /\s\+$/

" set up highlight group & retain through colorscheme changes
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
map <silent> <LocalLeader>ws :highlight clear ExtraWhitespace<CR>

" highlight too-long lines
autocmd BufRead,InsertEnter,InsertLeave * 2match LineLengthError /\%126v.*/
highlight LineLengthError ctermbg=black guibg=black
autocmd ColorScheme * highlight LineLengthError ctermbg=black guibg=black

" set quickfix window to appear after grep invocation
autocmd QuickFixCmdPost *grep* cwindow

" otherwise crontab editing doesn't work
autocmd filetype crontab setlocal nobackup nowritebackup

set laststatus=2
set statusline=
set statusline+=%<\                       " cut at start
set statusline+=%2*[%n%H%M%R%W]%*\        " buffer number, and flags
set statusline+=%-40f\                    " relative path
set statusline+=%=                        " seperate between right- and left-aligned
set statusline+=%1*%y%*%*\                " file type
set statusline+=%10(L(%l/%L)%)\           " line
set statusline+=%2(C(%v/125)%)\           " column
set statusline+=%P                        " percentage of file

set undodir=~/.vim/undodir
set undofile
set undolevels=1000 "maximum number of changes that can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

map <silent> <LocalLeader>nt :NERDTreeToggle<CR>
map <silent> <LocalLeader>nr :NERDTree<CR>
map <silent> <LocalLeader>nf :NERDTreeFind<CR>
let NERDTreeShowHidden=1
let g:NERDTreeIgnore = ['\~$', '\.beam$', '\.DS_Store$']

map <silent> <LocalLeader>cf :CtrlPClearCache<CR>

imap <C-L> <SPACE>=><SPACE>

"noremap <leader>p :set paste<CR>"*p<CR>:set nopaste<CR>
"noremap <leader>P :set paste<CR>"*P<CR>:set nopaste<CR>
"vnoremap <leader>y "*ygv

" window width
set winwidth=125
set winminwidth=10

noremap j gj
noremap k gk
noremap gj j
noremap gk k

" clean trailing whitespace
nnoremap <leader>rw mz:%s/\s\+$//<cr>:let @/=''<cr>`z

" Emacs bindings in command line mode
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" keep the cursor in place while joining lines
nnoremap J mzJ`z

" split line
" the normal use of S is covered by cc, so don't worry about shadowing it.
nnoremap S i<cr><esc>^mwgk:silent! s/\v +$//<cr>:noh<cr>`w

" disable help
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" convert dos format to unix format
noremap <leader>ff :update<CR>:e ++ff=dos<CR>:setlocal ff=unix<CR>:w<CR>

" HTML tag folding
nnoremap <leader>ft Vatzf

" CSS properties sorting
nnoremap <leader>S ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>

let vimclojure#HighlightBuiltins=0
let vimclojure#ParenRainbow=1

command! ScratchToggle call ScratchToggle()

function! ScratchToggle()
    if exists("w:is_scratch_window")
        unlet w:is_scratch_window
        exec "q"
    else
        exec "normal! :Sscratch\<cr>\<C-W>L"
        let w:is_scratch_window = 1
    endif
endfunction

command! CopyFilename call CopyFilename()

function! CopyFilename()
  let @" = expand("%")
endfunction

nnoremap <silent> <leader><tab> :ScratchToggle<cr>
nnoremap <silent> <leader>v :CopyFilename<cr>
" copy and paste to Mac OS X clipboard
" not working. it just goes to vim buffer. stupid vim.
" vnoremap <leader>y "*y

" Sandro Special
inoremap jk <ESC>

map <silent> <LocalLeader>go :Goyo<CR>
function! s:goyo_enter()
  set linebreak
  set noexpandtab
  highlight clear LineLengthError
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd QuitPre <buffer> let b:quitting = 1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction

function! s:goyo_leave()
  set expandtab
  if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

set wildignore+=tmp/*,vendor/*,*.png,*.jpg,*.tiff,*.pdf,*.svg,*.gif,*.cur,*.psd,*.eps,*.ico,node-modules/*,node_modules/*,**/node_modules/*,*.beam

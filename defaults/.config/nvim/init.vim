
call plug#begin()

Plug 'preservim/nerdtree'
Plug 'easymotion/vim-easymotion'
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'maximbaz/lightline-ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'OmniSharp/omnisharp-vim'
Plug 'nickspoons/vim-sharpenup'
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'sheerun/vim-polyglot'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'dense-analysis/ale'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-fugitive'
Plug 'frazrepo/vim-rainbow'
Plug 'miyakogi/conoline.vim'
Plug 'rbgrouleff/bclose.vim'
Plug 'ivalkeen/nerdtree-execute'
Plug 'mhinz/neovim-remote'
Plug 'lervag/vimtex'
Plug 'puremourning/vimspector'
Plug 'sirver/ultisnips'
Plug 'dyng/ctrlsf.vim'
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'
Plug 'sbdchd/neoformat'

call plug#end()


" Color sheme
set background=dark
colorscheme palenight

syntax on
filetype plugin indent on
let mapleader = ","
set modelines=0
set number 		" Show line numbers
set ruler 		" Show file stats
set visualbell		" Blink cursor on error (no audio beep)
set encoding=utf-8
set hidden 		" Allow hidden buffers
set laststatus=2 	" Show status bar
set showmode
set showcmd
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
set termguicolors
set mouse=a
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set number relativenumber
let g:rainbow_active = 1
let g:python3_host_prog = "/usr/bin/python3"
set clipboard+=unnamedplus

" Configure automatic toggling of hybrid line numbers
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup end

" Linting / ALE config
let g:ale_fix_on_save = 1
highlight clear ALEInfo
highlight ALEInfo cterm=underline ctermfg=39 gui=underline guifg=#00afff
highlight ALEWarning cterm=underline ctermfg=104 gui=underline guifg=#D19A66
let g:conoline_auto_enable = 1
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_sign_info = 'i'
let g:ale_sign_style_error = '✘'
let g:ale_sign_style_warning = '⚠'
let g:ale_linters = { 'cs': ['OmniSharp'], 'rust': ['rust-analyzer'] }
let g:ale_fixers = {
      \   'rust': ['rustfmt'],
      \}

nnoremap <leader>gd :ALEGoToDefinition<CR>
nnoremap <leader>fu :ALEFindReferences<CR>
nnoremap <leader>gh :ALEHover<CR>
nnoremap <leader>fs :ALESymbolSearch<CR>
nnoremap <leader><space> :ALEFixSuggest<CR>

" Commenting blocks of code.
autocmd FileType c,cpp,java,scala,cs    let b:comment_g = '// '
autocmd FileType sh,ruby,python         let b:comment_g = '# '
autocmd FileType conf,fstab             let b:comment_g = '# '
autocmd FileType tex                    let b:comment_g = '% '
autocmd FileType mail                   let b:comment_g = '> '
autocmd FileType vim                    let b:comment_g = '" '
noremap <silent> <leader>cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_g,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> <leader>cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_g,'\/')<CR>//e<CR>:nohlsearch<CR>

" EasyMotion stuff
let g:EasyMotion_do_mapping = 0 " Disable default mappings
nnoremap <space> <NOP>
nmap <space> <Plug>(easymotion-jumptoanywhere)
let g:EasyMotion_smartcase = 1
let g:EasyMotion_keys = 'hklyuiopnmqwertzxcvbasdjf'
let g:EasyMotion_re_anywhere = '\v' .
        \       '(<.|^$)' . '|' .
        \       '(_\zs.)' . '|' .
        \       '(#\zs.)'

" VimSpector
let g:vimspector_enable_mappings = 'HUMAN'
noremap <S-F5> :VimspectorReset<CR>

" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>tn :tabnew<cr>
noremap <leader>tc :tabclose<cr>
noremap <leader>tt :tabnew<cr>:terminal<cr>
noremap <leader>0 :tablast<cr>

" Cursor style
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

" Make it easy to move in wrapped lines
nnoremap k gk
nnoremap j gj

"NERDTree
" Auto close Nerdtree if its the only window left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree")
      \ && b:NERDTree.isTabTree()) | q | endif
let NERDTreeShowHidden=1
nmap <leader>bb :NERDTree<Return>
nmap <leader>bv :NERDTreeVCS<Return>
nnoremap <silent> <leader>bf :NERDTreeFind<CR>
let NERDTreeAutoDeleteBuffer = 1

" Split window
nmap ss :split<Return><C-w>w
nmap sv :vsplit<Return><C-w>w
" Move window
map s<left> <C-w>h
map s<up> <C-w>k
map s<down> <C-w>j
map s<right> <C-w>l
map sh <C-w>h
map sk <C-w>k
map sj <C-w>j
map sl <C-w>l
map si <C-w>+
map su <C-w>-
map so <C-w><
map sp <C-w>>

" Resize window
nmap <C-w><left> <C-w><
nmap <C-w><right> <C-w>>
nmap <C-w><up> <C-w>+
nmap <C-w><down> <C-w>-

" Misc Keybindings
nmap t o<Esc>
nmap T O<Esc>
map <F1> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
map <leader>wu :execute "vimgrep /" . expand("<cword>") . "/j **" <Bar> cw<CR>   " Search in files for word under cursor
map <leader>fg :Ag<CR>

" Terminal mode
:tnoremap <Esc> <C-\><C-n>
nmap <leader>nt ss:terminal<CR>20su
nmap <leader>q :Bclose<CR>

" FzF
"map <C-p> :Files<Return>
nnoremap <expr> <C-p> (len(system('git rev-parse')) ? ':Files' : ':GFiles --exclude-standard --others --cached')."\<cr>"
let $FZF_DEFAULT_COMMAND = 'find .'

" Git stuff
nmap <leader>gb :Gblame<CR>
nmap <leader>gs :G<CR>
nmap <leader>gu :Gpull<CR>
nmap <leader>gp :GPush<CR>
nmap <leader>gc :Gvdiff<CR>
nmap <leader>gh :diffget //2 <bar> diffup<CR>
nmap <leader>gl :diffget //3 <bar> diffup<CR>
nnoremap <leader>sr :%s/

" Latex config
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_general_viewer = 'zathura'
let g:vimtex_view_method = 'zathura'
nnoremap <leader>sg :CtrlSF<Space>
nmap <leader>lc :VimtexCompile<CR>

" CoC config
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint', 
  \ 'coc-prettier', 
  \ 'coc-json', 
  \ 'coc-omnisharp',
  \ ]

" Global Search with CtrlSF
let g:ctrlsf_regex_pattern = 1
let g:ctrlsf_default_view_mode = 'compact'
let g:ctrlsf_auto_focus = {
    \ "at": "start"
    \ }

" Neoformat
nmap <leader>cf :Neoformat<CR>

"Omnisharp config
source ~/.config/nvim/omnisharp.vim
source ~/.config/nvim/rust.vim
source ~/.config/nvim/colorscheme.vim

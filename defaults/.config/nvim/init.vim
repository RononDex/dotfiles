call plug#begin()

Plug 'preservim/nerdtree'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'https://github.com/nvim-treesitter/playground.git'
Plug 'https://github.com/nvim-treesitter/nvim-treesitter-context'
Plug 'https://github.com/tpope/vim-commentary'
Plug 'https://github.com/JoosepAlviste/nvim-ts-context-commentstring.git'
Plug 'https://github.com/lewis6991/spellsitter.nvim.git'
Plug 'phaazon/hop.nvim'
Plug 'itchyny/lightline.vim'
Plug 'NovaDev94/lightline-onedark'
Plug 'editorconfig/editorconfig-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'josa42/vim-lightline-coc'
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'tpope/vim-fugitive'
Plug 'frazrepo/vim-rainbow'
Plug 'miyakogi/conoline.vim'
Plug 'rbgrouleff/bclose.vim'
Plug 'ivalkeen/nerdtree-execute'
Plug 'mhinz/neovim-remote'
Plug 'lervag/vimtex'
Plug 'puremourning/vimspector'
Plug 'dyng/ctrlsf.vim'
Plug 'rust-lang/rust.vim'
Plug 'vim-test/vim-test'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'ryanoasis/vim-devicons'
Plug 'tyru/open-browser.vim'  " Depenendency of plantuml-previewer
Plug 'aklt/plantuml-syntax' " Depenendency of plantuml-previewer
Plug 'weirongxu/plantuml-previewer.vim'

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
set tabstop=4 
set number relativenumber
let g:rainbow_active = 1
let g:python3_host_prog = "/usr/bin/python3"
set clipboard+=unnamedplus
set nospell

" Configure automatic toggling of hybrid line numbers
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup end

" Lightline config
let g:lightline = {
  \   'active': {
  \     'left': [[  'coc_info', 'coc_hints', 'coc_errors', 'coc_warnings', 'coc_ok' ], [ 'coc_status'  ]]
  \   },
  \   'colorscheme': 'onedark',
  \   'cSpellExt.enableDictionaries': ["german, english"],
  \   'cSpell.language' : 'de,en'
  \ }

" register compoments:
call lightline#coc#register()

" Commenting blocks of code.
autocmd FileType c,cpp,java,scala,cs    let b:comment_g = '// '
autocmd FileType sh,ruby,python         let b:comment_g = '# '
autocmd FileType conf,fstab             let b:comment_g = '# '
autocmd FileType tex                    let b:comment_g = '% '
autocmd FileType mail                   let b:comment_g = '> '
autocmd FileType vim                    let b:comment_g = '" '
noremap <silent> <leader>cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_g,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> <leader>cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_g,'\/')<CR>//e<CR>:nohlsearch<CR>

" Vim-test settings
nmap <silent> <leader>tr :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ts :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tv :TestVisit<CR>

" Hop stuff
:lua require'hop'.setup()
nnoremap <space> <NOP>
nmap <space> :HopWord<CR>

" VimSpector
let g:vimspector_enable_mappings = 'HUMAN'
nnoremap <leader><F5> :VimspectorReset<CR>

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

" Tab settings
inoremap <S-Tab> <C-D>
vnoremap <Tab> <C-v><Tab>
vnoremap <S-Tab> <gv
noremap <Leader> t :set invexpandtab<CR>
noremap <Leader><Leader><Tab> :set invlist<CR>

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
let g:NERDTreeWinSize = 50

" Md preview
nmap <leader>mp <Plug>MarkdownPreviewToggle

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
map <leader><F1> :TSHighlightCapturesUnderCursor<cr>
map <leader>wu :execute "vimgrep /" . expand("<cword>") . "/j **" <Bar> cw<CR>   " Search in files for word under cursor
map <leader>fg :Ag<CR>
nnoremap <leader>sr :%s/

" Terminal mode
:tnoremap <Esc> <C-\><C-n>
nmap <leader>nt ss:terminal<CR>20su
nmap <leader>q :Bclose<CR>

" FzF
"map <C-p> :Files<Return>
nnoremap <expr> <C-p> (len(system('git rev-parse')) ? ':Files' : ':GFiles --exclude-standard --others --cached')."\<cr>"
let $FZF_DEFAULT_COMMAND = 'find .'

" Git stuff
nmap <leader>gb :Git blame<CR>
nmap <leader>gs :G<CR>
nmap <leader>gu :Git pull<CR>
nmap <leader>gp :Git push<CR>
nmap <leader>gc :Gvdiff<CR>
nmap <leader>gh :diffget //2 <bar> diffup<CR>
nmap <leader>gl :diffget //3 <bar> diffup<CR>
nmap <leader>gm :Git mergetool -y<CR>
nmap J ']c'
nmap K '[c'

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
  \ 'coc-json', 
  \ 'coc-java',
  \ 'coc-html',
  \ 'coc-css',
  \ 'coc-java-debug',
  \ 'coc-rust-analyzer',
  \ 'coc-texlab',
  \ 'coc-spell-checker',
  \ 'coc-cspell-dicts',
  \ 'coc-sh',
  \ 'coc-pyright',
  \ 'coc-xml',
  \ 'coc-csharp-ls',
  \ 'coc-clangd',
  \ ]

" allows to use enter to select an entry in the auto complete window
inoremap <expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<CR>"

" gd - go to definition of word under cursor
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> <leader>fd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)

" gi - go to implementation
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> <leader>fi <Plug>(coc-implementation)

" fu - find usages
nmap <silent> <leader>fu <Plug>(coc-references)

" gh - get hint on whatever's under the cursor
nnoremap <silent> K :call <SID>show_documentation()<CR>
nnoremap <silent> gh :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

nnoremap <silent> <leader>co  :<C-u>CocList outline<cr>
" Find symbol
nnoremap <silent> <leader>fs  :<C-u>CocList -I symbols<cr>

" List errors
nnoremap <silent> <leader>cl  :<C-u>CocList locationlist<cr>

" restart when tsserver gets wonky
nnoremap <silent> <leader>cR  :<C-u>CocRestart<CR>

" view all errors
nnoremap <silent> <leader>cl  :<C-u>CocList locationlist<CR>

" manage extensions
nnoremap <silent> <leader>cx  :<C-u>CocList extensions<cr>

" rename the current word in the cursor
nmap <leader>cr  <Plug>(coc-rename)
nmap <F2>        <Plug>(coc-rename)
nmap <leader>cf  <Plug>(coc-format)
vmap <leader>cf  <Plug>(coc-format-selected)

" run code actions
vmap <leader>ca  <Plug>(coc-codeaction-selected)
vmap <leader><space>  <Plug>(coc-codeaction-selected)
nmap <leader><space>  v<Plug>(coc-codeaction-selected)



" Global Search with CtrlSF
let g:ctrlsf_regex_pattern = 1
let g:ctrlsf_default_view_mode = 'compact'
let g:ctrlsf_auto_focus = {
    \ "at": "start"
    \ }

" PlantUML
nnoremap <leader>uml :PlantumlOpen<CR>

" Neoformat
nmap <leader>nf :Neoformat<CR>

" Spellchecking
set spelllang=en,de-ch
set spellsuggest=best,9
nnoremap <silent> <leader>sc :set spell!<cr>

source ~/.config/nvim/rust.vim
source ~/.config/nvim/colorscheme.vim
source ~/.config/nvim/java.vim
source ~/.config/nvim/cpp.vim
lua require("config.treesitter")
lua require("config.spellsitter")

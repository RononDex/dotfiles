" Snippet support

call plug#end()
" }}}

" Settings: {{{
filetype indent plugin on
if !exists('g:syntax_on') | syntax enable | endif
set encoding=utf-8
scriptencoding utf-8


" NeoVim does not support popups yet: https://github.com/neovim/neovim/issues/10996
" Reenable when support is added
"set completeopt=menuone,noinsert,noselect,popuphidden
"set completepopup=highlight:Pmenu,border:off

set expandtab
set shiftround
set shiftwidth=4
set softtabstop=-1
set tabstop=4
set textwidth=120

set nofixendofline
set nostartofline

set signcolumn=yes

set updatetime=400
" }}}


" Use truecolor in the terminal, when it is supported
if has('termguicolors')
  set termguicolors
endif

" }}}


"
"" Lightline: {{{
let g:lightline = {
\ 'colorscheme': 'onedark',
\ 'active': {
\   'right': [
\     ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok'],
\     ['lineinfo'], ['percent'],
\     ['fileformat', 'fileencoding', 'filetype', 'sharpenup']
\   ]
\ },
\ 'inactive': {
\   'right': [['lineinfo'], ['percent'], ['sharpenup']]
\ },
\ 'component': {
\   'sharpenup': sharpenup#statusline#Build()
\ },
\ 'component_expand': {
\   'linter_checking': 'lightline#ale#checking',
\   'linter_infos': 'lightline#ale#infos',
\   'linter_warnings': 'lightline#ale#warnings',
\   'linter_errors': 'lightline#ale#errors',
\   'linter_ok': 'lightline#ale#ok'
  \  },
  \ 'component_type': {
  \   'linter_checking': 'right',
  \   'linter_infos': 'right',
  \   'linter_warnings': 'warning',
  \   'linter_errors': 'error',
  \   'linter_ok': 'right'
\  }
\}
" Use unicode chars for ale indicators in the statusline
let g:lightline#ale#indicator_checking = "\uf110 "
let g:lightline#ale#indicator_infos = "\uf129 "
let g:lightline#ale#indicator_warnings = "\uf071 "
let g:lightline#ale#indicator_errors = "\uf05e "
let g:lightline#ale#indicator_ok = "\uf00c "
" }}}

" Asyncomplete: {{{
let g:asyncomplete_auto_popup = 1
"let g:asyncomplete_auto_completeopt = 0
" }}}

" Sharpenup: {{{
" All sharpenup mappings will begin with `<Leader>os`, e.g. `<Leader>osgd` for
" :OmniSharpGotoDefinition
let g:sharpenup_map_prefix = '<Leader>os'

let g:sharpenup_statusline_opts = { 'Text': '%s (%p/%P)' }
let g:sharpenup_statusline_opts.Highlight = 0

augroup OmniSharpIntegrations
  autocmd!
  autocmd User OmniSharpProjectUpdated,OmniSharpReady call lightline#update()
augroup END
" }}}

" OmniSharp: {{{
let g:OmniSharp_popup_position = 'peek'
if has('nvim')
  let g:OmniSharp_popup_options = {
  \ 'winhl': 'Normal:NormalFloat'
  \}
else
  let g:OmniSharp_popup_options = {
  \ 'highlight': 'Normal',
  \ 'padding': [0, 0, 0, 0],
  \ 'border': [1]
  \}
endif
let g:OmniSharp_popup_mappings = {
\ 'sigNext': '<C-n>',
\ 'sigPrev': '<C-p>',
\ 'pageDown': ['<C-f>', '<PageDown>'],
\ 'pageUp': ['<C-b>', '<PageUp>']
\}

let g:OmniSharp_want_snippet = 1
" }}}

filetype indent plugin on
let g:OmniSharp_server_stdio = 1
let g:OmniSharp_server_display_loading = 1
let g:OmniSharp_highlighting = 3
let g:OmniSharp_highlight_types = 3
let g:OmniSharp_selector_ui = 'fzf'
let g:OmniSharp_diagnostic_showid = 1
let g:OmniSharp_timeout = 5
let g:ale_linters = { 'cs': ['OmniSharp'] }
let g:OmniSharp_diagnostic_listen = 0

augroup omnisharp_commands
    autocmd!

    " Show type information automatically when the cursor stops moving.
    " Note that the type is echoed to the Vim command line, and will overwrite
    " any other messages in this space including e.g. ALE linting messages.
    "autocmd CursorHold *.cs OmniSharpTypeLookup

    " The following commands are contextual, based on the cursor position.
    autocmd FileType cs nnoremap <buffer> <Leader>gd :OmniSharpGotoDefinition<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>

    " Finds members in the current buffer
    autocmd FileType cs nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>

    autocmd FileType cs nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>ti :OmniSharpTypeLookup<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>
    autocmd FileType cs nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
    autocmd FileType cs inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>

    " Navigate up and down by method/property/field
    autocmd FileType cs nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
    autocmd FileType cs nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>

    " Run tests
    autocmd FileType cs nnoremap <buffer> <leader>rt :OmniSharpRunTest<CR>

    " Contextual code actions (uses fzf, CtrlP or unite.vim when available)
    autocmd FileType cs nnoremap <Leader><Space> :OmniSharpGetCodeActions<CR>
    " Run code actions with text selected in visual mode to extract method
    autocmd FileType cs xnoremap <Leader><Space> :call OmniSharp#GetCodeActions('visual')<CR>

    " Rename with dialog
    autocmd FileType cs nnoremap <Leader>nm :OmniSharpRename<CR>
    autocmd FileType cs nnoremap <F2> :OmniSharpRename<CR>
    " Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
    autocmd FileType cs command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

    autocmd FileType cs nmap <Leader>cf :OmniSharpCodeFormat<CR>

    "Show documentations
    autocmd FileType cs nnoremap <Leader>ch :OmniSharpSignatureHelp<CR>
    autocmd FileType cs nnoremap <Leader>ct :OmniSharpDocumentation<CR>

    autocmd FileType cs nmap <F1> :OmniSharpHighlightEcho<CR>
augroup END


" Start the omnisharp server for the current solution
nnoremap <Leader>ss :OmniSharpStartServer<CR>
nnoremap <Leader>sp :OmniSharpStopServer<CR>

" Ignore certain warnings
let g:OmniSharp_diagnostic_overrides = {
\ 'CSE0003': { 'type': 'None'},
\ 'CC0038': {'type': 'None'},
\ 'CS1701': {'type': 'I'},
\ 'IDE0058': {'type': 'None'},
\ 'IDE0008': {'type': 'None'},
\ 'CC0045': {'type': 'None'},
\ 'CC0042': {'type': 'None'},
\ 'CC0071': {'type': 'I'},
\ 'MA0076': {'type': 'None'},
\ 'CC0003': {'type': 'W'},
\ 'CC0088': { 'type': 'None'},
\ 'CC0046': { 'type': 'None'},
\ 'CC0079': { 'type': 'None'},
\ 'RCS1006': { 'type': 'None'},
\ 'CC0076': { 'type': 'None'},
\ 'CC0035': { 'type': 'None'},
\ 'RCS1183': { 'type': 'None'},
\ 'RCS1090': { 'type': 'None'},
\ 'IDE0022': { 'type': 'None'},
\ 'RemoveUnnecessaryImportsFixable': {'type': 'I'}
\}

" Highlighting Groups
let g:OmniSharp_highlight_groups = {
\ 'Comment': 'Comment',
\ 'Keyword': 'Keyword',
\ 'StringLiteral': 'String',
\ 'ClassName': 'StorageClass',
\ 'DelegateName': 'StorageClass',
\ 'EnumName': 'StorageClass',
\ 'InterfaceName': 'StorageClass',
\ 'ModuleName': 'StorageClass',
\ 'StructName': 'StorageClass',
\ 'ConstantName': 'Constant',
\ 'NamespaceName': 'Include',
\ 'ExcludedCode': 'NonText'
\}

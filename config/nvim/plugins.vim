" options relating to plugin automation were taken from the below
" https://github.com/kelp/nvim/blob/master/home/.config/nvim/init.vim

" Plug Install {{{
"
" Plugins are installed with vim-plug
"

" Utility to run PlugInstall and guard against loading color schemes
" before we're ready.
if !exists('*SetupPlug')
  function SetupPlug()
    let g:not_finish_vimplug = "yes"
    PlugInstall --sync
    unlet g:not_finish_vimplug
    "set verbose=15
    source $MYVIMRC | q
    "set verbose=0
  endfunction
endif

" check whether vim-plug is installed and install it if necessary
"let plugpath = expand('<sfile>:p:h'). '/autoload/plug.vim'
let plugpath = expand('~/.local/share/nvim/site/autoload/plug.vim')
if !filereadable(plugpath)
    if executable('curl')
        echo "Installing vim-plug..."
        echo ""
        let plugurl = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        call system('curl -fLo ' . shellescape(plugpath) . ' --create-dirs ' . plugurl)
        if v:shell_error
            echom "Error downloading vim-plug. Please install it manually.\n"
            exit
        endif
    else
        echom "vim-plug not installed. Please install it manually or install curl.\n"
        exit
    endif
endif

" Install missing plugins on startup
augroup initvim-vimplug
  autocmd!
  autocmd VimEnter *
    \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \|   call SetupPlug()
    \| endif
augroup END

" Shortcut to upgrade all plugins, including Plug
command! PU PlugUpdate | PlugUpgrade

" }}}
"
" {{{ Plugins
"

call plug#begin(stdpath('data') . '/plugged')

  " OCS52 yank
  Plug 'ojroques/vim-oscyank'

  " suda plugin, enable overwriting files with sudo
  " `let g:suda_smart_edit=1` enables auto switch when target is not readable
  Plug 'lambdalisue/suda.vim'

  " tpope's plugins that should be part of vim
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'

  " Git integration
  Plug 'tpope/vim-fugitive'

  " fzf needs no introduction
  "Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  " workaround to the error:
  " 'Post-update hook for fzf ... /usr/share/nvim/runtime/install not found'
  Plug 'junegunn/fzf', { 'do': 'yes \| ./install' }
  Plug 'junegunn/fzf.vim'

  " fzf checkout
  Plug 'stsewd/fzf-checkout.vim'

  " Intellisense Engine
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'antoinemadec/coc-fzf', {'branch': 'release'}

  " Markdown preview
  "Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}
  Plug 'previm/previm'

call plug#end()

" }}}
"
" {{{ Plugin Settings
"

" override ocsyank terminal auto detection, set as tmux
" I use this mostly for ssh yanks from a host running tmux
let g:oscyank_term = 'tmux'

" fzf options
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
" let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.8, 'yoffset': 0, 'border': 'bottom', 'highlight': 'Todo' } }
" let g:fzf_layout = { 'down': '~40%' } " use terminal window
" let g:fzf_layout = { 'window': 'enew' } " use vim window

" <F2>        toggle preview
" <C-w>       toggle preview text wrap
" <C-d>|<C-u> half page down|up
" <C-l>       clear query
let $FZF_DEFAULT_OPTS = '--layout=reverse --preview-window="border:nowrap" --info=inline --multi --bind="f2:toggle-preview,ctrl-w:toggle-preview-wrap,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-f:page-down,ctrl-b:page-up,ctrl-a:toggle-all,ctrl-l:clear-query"'

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

" Ctrl-q allows to select multiple elements an open them in quick list
let g:fzf_action = {
      \ 'ctrl-q': function('s:build_quickfix_list'),
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit' }

" Prefix all fzf.vim exported commands with "Fzf"
let g:fzf_command_prefix = 'Fzf'

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" Preview window options
let g:fzf_preview_window = ['right:50%:nowrap']

" Fzf quickfix browser
source ~/.config/nvim/fzf-qf.vim

" Coc mappings for fzf lists https://github.com/antoinemadec/coc-fzf
let g:coc_fzf_preview='down:50%:nohidden'
let g:coc_fzf_opts=['--layout=reverse', '--info=inline', '--multi']

" Define fzf-checkout only actions as branch, checkout, diff, delete
" we use <ctrl-x> to maintain confirmity with our zsh map
let g:fzf_branch_actions = {
      \ 'delete': {'keymap': 'ctrl-x'},
      \ 'diff': {
      \   'prompt': 'Diff> ',
      \   'execute': 'Git diff {branch}',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-f',
      \   'required': ['branch'],
      \   'confirm': v:false,
      \ },
      \ 'checkout': {
      \   'prompt': 'Checkout> ',
      \   'execute': 'echo system("{git} checkout {branch}")',
      \   'multiple': v:false,
      \   'keymap': 'enter',
      \   'required': ['branch'],
      \   'confirm': v:false,
      \ },
      \}


" coc.nvim note regarding workspace folders:
" https://github.com/neoclide/coc.nvim/wiki/Using-workspaceFolders
" we must set the  "coc.preferences.rootPatterns" in coc-settings
" to help coc decide which is workspace folder if the pattern exists
" the default settings considers every folder with ".git" a workspace
" to support Lua linting in a non git folder I added ".luacheckrc" to
" the list of rootPatterns, this made it possible to send the correct
" info to lua-lsp so that it would load .luacheckrc for luacheck
" to see the list of loaded root patterns use:
" :echo coc#util#root_patterns()
" to see the current list of workspace folders:
" :CocList folders

" coc.vim will install any missing extensions
let g:coc_global_extensions = [
      \ "coc-explorer",
      \ "coc-lua",
      \ "coc-tsserver",
      \ "coc-css",
      \ "coc-html",
      \ "coc-json",
      \ "coc-prettier",
  \]

command! -nargs=0 Prettier :CocCommand prettier.formatFile

let g:coc_explorer_global_presets = {
\   '.nvim': {
\      'root-uri': '~/.config/nvim',
\   },
\   'floating': {
\      'position': 'floating',
\   },
\   'floatingLeftside': {
\      'position': 'floating',
\      'floating-position': 'left-center',
\      'floating-width': 50,
\   },
\   'floatingRightside': {
\      'position': 'floating',
\      'floating-position': 'right-center',
\      'floating-width': 50,
\   },
\   'simplify': {
\     'file.child.template': '[selection | clip | 1] [indent][icon | 1] [filename omitCenter 1]'
\   }
\ }

" suda plugin
" https://github.com/lambdalisue/suda.vim
let g:suda_smart_edit = 1

" markdown-preview
" do not close the preview tab when switching to other buffers
let g:mkdp_auto_close = 0

" previm
let g:previm_open_cmd = 'firefox'

" }}}

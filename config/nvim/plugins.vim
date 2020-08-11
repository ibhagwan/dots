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

  " suda plugin, enable overwriting files with sudo
  " `let g:suda_smart_edit=1` enables auto switch when target is not readable
  Plug 'lambdalisue/suda.vim'

  " tpope's plugins that should be part of vim
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'

  " Git integration
  Plug 'tpope/vim-fugitive'

  " Denite
  Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }

  " LeaderF
  Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
  Plug 'Yggdroot/LeaderF-marks'

  " Intellisense Engine
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  " Markdown preview
  "Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}
  Plug 'previm/previm'

call plug#end()

" }}}
"
" {{{ Plugin Settings
"

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

" LeaderF settings
" don't show the help in normal mode
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_IgnoreCurrentBufferName = 1
let g:Lf_ShowRelativePath = 1
let g:Lf_CursorBlink = 0
let g:Lf_StlColorscheme = 'dark'
let g:Lf_JumpToExistingWindow = 1
" popup mode
let g:Lf_WindowPosition = 'popup'
let g:Lf_PopupPosition =  [1, 0]
let g:Lf_PopupPreviewPosition = 'bottom'
let g:Lf_PopupShowStatusline = 1
let g:Lf_PreviewInPopup = 1
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "Monospace" }
let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }

let g:Lf_RgConfig = [
        \ "--max-columns=150",
        \ "--glob=!git/*",
        \ "--hidden"
    \ ]



" === Denite setup ==="
" offcial doc:
"   https://github.com/Shougo/denite.nvim/blob/master/doc/denite.txt
" Shougo's own vim.rc:
"   https://github.com/Shougo/shougo-s-github/blob/master/vim/rc/plugins/denite.rc.vim
"   https://github.com/Shougo/shougo-s-github/blob/master/vim/rc/deinlazy.toml#L146-L219
" Caleb Taylor's config:
"   https://github.com/ctaylo21/jarvis/tree/master/config/nvim
"

" TODO: fix: make denite window cursor line have no bg
hi CursorLineNoBg ctermfg=7 ctermbg=NONE cterm=bold,underline
function s:DeniteCursorLine()
  if (bufname('%') =~ "denite")
    :set winhighlight=CursorLine:CursorLineNoBg
    return v:true
  else
    return v:false
  endif
endfunction
"autocmd BufEnter * call s:DeniteCursorLine()

" Wrap in try/catch to avoid errors on initial install before plugin is available
try

" Use ripgrep for searching current directory for files
" By default, ripgrep will respect rules in .gitignore
"   --files: Print each file that would be searched (but don't search)
"   --glob:  Include or exclues files for searching that match the given glob
"            (aka ignore .git files)
"
"call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])
call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '*'])

" Use ripgrep in place of "grep"
call denite#custom#var('grep', 'command', ['rg'])

" Custom options for ripgrep
"   --vimgrep:  Show results with every match on it's own line
"   --hidden:   Search hidden directories and files
"   --heading:  Show the file name above clusters of matches from each file
"   --S:        Search case insensitively if the pattern is all lowercase
call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

" Recommended defaults for ripgrep via Denite docs
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Remove date from buffer list
call denite#custom#var('buffer', 'date_format', '')

" Custom options for Denite
"   auto_resize             - Auto resize the Denite window height automatically.
"   prompt                  - Customize denite prompt
"   direction               - Specify Denite window direction as directly below current pane
"   winminheight            - Specify min height for Denite window
"   highlight_mode_insert   - Specify h1-CursorLine in insert mode
"   prompt_highlight        - Specify color of prompt
"   highlight_matched_char  - Matched characters highlight
"   highlight_matched_range - matched range highlight
let s:denite_options = {'default' : {
\ 'split': 'floating',
\ 'filter_split_direction': 'floating',
\ 'start_filter': v:false,
\ 'auto_resize': v:true,
\ 'source_names': 'short',
\ 'prompt': 'λ ',
\ 'highlight_matched_char': 'QuickFixLine',
\ 'highlight_matched_range': 'Visual',
\ 'highlight_window_background': 'Visual',
\ 'highlight_filter_background': 'DiffAdd',
\ 'winrow': 1,
\ 'vertical_preview': v:true,
\ 'floating_preview': v:false
\ }}

" Loop through denite options and enable them
function! s:profile(opts) abort
  for l:fname in keys(a:opts)
    for l:dopt in keys(a:opts[l:fname])
      call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
    endfor
  endfor
endfunction

call s:profile(s:denite_options)
catch
  echo 'Denite not installed. It should work after running :PlugInstall'
endtry

" }}}


if &compatible
  set nocompatible        " If called from vim, make sure it's nocompatible
endif

" support mouse operations (click, scroll, etc)
" also prevents copying line # when using mouse
" actually scrap that, disable mouse everywhere
if has('mouse')
  set mouse-=a
endif

colorscheme ibhagwan      " set our custom color scheme

set ruler                 " show line,col at the nvim cmdline
set showmode              " show current mode (insert, etc) under the cmdline
set showcmd               " show current command under the cmd line
set cmdheight=1           " cmdline height
set laststatus=2          " 2 = always show status line (filename, etc)
set scrolloff=3           " min number of lines to keep between cursor and screen edge
set number                " show the number ruler
set relativenumber        " show relative numbers in the ruler
set splitbelow splitright " splits open bottom right

if has('nvim')
  set cursorline          " Show a line where the current cursor is
  set wildoptions=pum     " Show completion items using the pop-up-menu (pum)
" set pumblend=8          " Give the pum some transparency

  highlight PmenuSel blend=0

  " Make sure the terminal buffer has no numbers and no sign column
  " Always open on insert mode
  augroup initvim-term
    autocmd!
    autocmd TermOpen * :setlocal signcolumn=no nonumber norelativenumber
    autocmd TermOpen term://* startinsert
    autocmd BufLeave term://* stopinsert
  augroup END
  " <Esc> for normal mode
  " <Alt-[> or <C-v><Esc> to send <C-[> to term
  " <C-o> to jump back
  " <C-r> to simulate i-<C-r> (expression register)
  tnoremap <Esc> <C-\><C-n>
  tnoremap <M-[> <Esc>
  tnoremap <C-v><Esc> <Esc>
  tnoremap <C-o> <C-\><C-n><C-o>
  tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
  " Shortcut commands for term splits
  command! -nargs=* T split | terminal <args>
  command! -nargs=* VT vsplit | terminal <args>
endif

" Enable 24 bit colors if we can
if (has("termguicolors"))
  "set termguicolors
  syntax on
else
  set t_Co=8
endif

"show the current unicode character value in the statusline
"https://vim.fandom.com/wiki/Showing_the_ASCII_value_of_the_current_character
"set statusline=%02n:%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P

" invisible characters to use on ':set list'
set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨,space:␣
set showbreak=↪\
" find out which char you want using the below
" `xfd -fn -xos4-terminus-medium-r-normal--32-320-72-72-c-160-iso10646-1`
" `xfd -fa "InputMono Nerd Font"`
" special chars can be inputed in nvim with the sequence
" `ctrl-v, u, xxxx` xxxx being the char hex code
" 0x2587=▇
" 0x2591=░
" 0x2592=▒
" 0x21bb=↻
" 0x21b5=↵
" 0x2192=→
"set listchars=tab:→\ ,eol:↵,nbsp:▒,trail:•,extends:⟩,precedes:⟨,space:▇
"set showbreak=↻\
set wrap breakindent    " start wrapped lines indented
set linebreak           " do not break words on wrap

" default <tab> behavior
set tabstop=2           " Tab indentation levels every two columns
set softtabstop=2       " Tab indentation when mixing tabs & spaces
set shiftwidth=2        " Indent/outdent by two columns
set shiftround          " Always indent/outdent to nearest tabstop
set expandtab           " Convert all tabs that are typed into spaces
set smarttab            " Use shiftwidths at left margin, tabstops everywhere else

" searching
set hlsearch            " highlight all text matching current search pattern
set incsearch           " show search matches as you type
set ignorecase          " ignore case on search
set smartcase           " case sensitive when search includes uppercase
set showmatch           " highlight matching [{()}]
set splitbelow          " open new splits on the bottom
set splitright          " open new splits on the right"
set inccommand=nosplit  " show search and replace in real time
set autoread            " reread a file if it's changed outside of vim
set wrapscan            " begin search from top of the file when nothng is found
set cpoptions+=x        " stay at seach item when <esc>

" vim clipboard copies to system clipboard
" unnamed     = use the " register (cmd-s paste in our term)
" unnamedplus = use the + register (cmd-v paste in our term)
set clipboard=unnamedplus

" text formatting
set encoding=utf-8

" hack to work around vim-plug auto install harmless error
" due to `source $MYVIMRC | q` in SetupPlug()
" 'Cannot make changes, 'modifiable' is off: fileencoding=utf-8'
try
  set fileencoding=utf-8
catch
endtry

set noswapfile          " No swap files

set path=.,,,$PWD/**    " recursive search when using :find
set wildmenu            " visual autocomplete for the command menu
set lazyredraw          " redraw only when we need to.
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level
"set colorcolumn=80     " mark column 80
set modelines=1         " read a modeline on the last line of the file
set autoindent          " autoindent
set smartindent         " add <tab> depending on syntax (C/C++)
"set diffopt+=vertical  " :Gdiffsplit vertical split (vim-fugitive)
                        " use :Gvdiffsplit :Ghdiffsplit

" show menu even for one item do not auto select/insert
" IMPORTANT: :help Ncm2PopupOpen for more information
 set completeopt=noinsert,menuone,noselect

" recommended settings for coc.vim
set hidden              " TextEdit might fail if hidden is not set.
set nobackup            " Some servers have issues with backup files, see #649:
set nowritebackup       " https://github.com/neoclide/coc.nvim/issues/649
"set cmdheight=2        " Give more space for displaying messages.

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved. We set this individually for code files
"set signcolumn=yes

" `viminfo` is deprecated, we use &shada instead
" • '100 Marks will be remembered for the last 100 edited files.
" • <1000 Limits the number of lines saved for each register to 1000 lines;
"   if a register contains more than 1000 lines, only the first 1000 lines are saved.
" • s100 Registers with more than 100 KB of text are skipped.
" • h Disables search highlighting when Vim starts.
set shada=!,'100,<1000,s100,h

" Python setup
if has('nvim')
  let g:python_host_prog  = '/usr/bin/python2'
  let g:python3_host_prog = '/usr/bin/python3'
endif

" Markdown fencing syntax
" highlight fenced code blocks in markdown
let g:markdown_fenced_languages = [
      \ 'cpp',
      \ 'html',
      \ 'vim',
      \ 'js=javascript',
      \ 'json',
      \ 'python',
      \ 'sql',
      \ 'bash=sh'
      \ ]

" don't use our plugins and extended settings
" if we're executing this from sudo/doas
let id=system('id -u')
if id != 0

  " Keybinds
  source ~/.config/nvim/keymap.vim

  " Filetypes
  source ~/.config/nvim/filetypes.vim

  " Plugins
  source ~/.config/nvim/plugins.vim

endif

if has("autocmd")
  " disable auto commenting, must be last line as plugins may overwrite
  " this gets overwritten by `filetypes.vim` for ceratin types
  " c: Auto-wrap comments using textwidth, inserting the current comment
  " r:  Automatically insert the current comment leader after hitting
  "     <Enter> in Insert mode.
  " o: Automatically insert the current comment leader after hitting 'o' or
  "     'O' in Normal mode.
  "augroup initvim-formatopts
  "  autocmd!
  "  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
  "augroup END

  " Sync syntax from the start of the file when opening a buffer
  " otherwise syntax highlight might get out of sync when scrolling
  " supposdely has some performance issues?
  augroup initvim-syncformat
    autocmd!
    autocmd BufEnter * :syntax sync fromstart
  augroup END

  " Source the vimrc file after saving it
  augroup initvim-source
    autocmd!
    autocmd bufwritepost init.vim,keymap.vim,plugins.vim,filetypes.vim,ibhagwan.vim
      \ source $MYVIMRC
  augroup END
endif

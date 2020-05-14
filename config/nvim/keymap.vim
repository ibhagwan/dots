" {{{ Keymaps
"

" map leader as <space>
nnoremap <Space> <nop>
let mapleader ="\<Space>"

" by default `d` is a 'cut' operation into the unnamedplus (+) register
" which in our case is the clipboard, bind <space>d to "real delete" op
" <space>v and <space>s are used to mimc term cmd-v and cmd-s pastes
" <space>y and <space>Y paste directly from the yank register (0)
" https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text
nnoremap <leader>v "+p
xnoremap <leader>v "+p
nnoremap <leader>s "*p
xnoremap <leader>s "*p
nnoremap <leader>p "0p
xnoremap <leader>p "0p
nnoremap <leader>P "0P
xnoremap <leader>P "0P
" <space>b as a shortcut to the 'blackhole' register
" <space>d|dd|D is mapped "real delete"
" x|c do not copy deleted text to register
nnoremap <leader>b "_
nnoremap <leader>d "_d
nnoremap <leader>D "_D
nnoremap <leader>dd "_dd
"nnoremap x "_x
"nnoremap c "_c
"nnoremap C "_C
"nnoremap cc "_cc
" Visual mode mappings
" so we can use idioms like `vxp` to transpose chars
" and `viwc[<c-r>+]` to surround objects ([])
xnoremap <leader>b "_
xnoremap <leader>d "_D
xnoremap <leader>D "_D
xnoremap <leader>x "_x
"xnoremap x "_x
"xnoremap c "_c
"xnoremap C "_C
" Map `Y` to copy to end of line
" conistent with the behaviour of `C` and `D`
nnoremap Y y$
xnoremap Y <Esc>y$gv

" Map `cp` to `xp` (transpose two adjacent chars)
" as a **repeatable action** with `.`
" (since the `@=` trick doesn't work
"nmap cp @='xp'<CR>
nmap cp <Plug>TransposeCharacters
nnoremap  <Plug>TransposeCharacters xp
  \:call repeat#set("\<Plug>TransposeCharacters")<CR>

" Fix some common typos
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

" Beginning and end of line
"imap <C-a> <home>
"imap <C-e> <end>
cmap <C-a> <home>
cmap <C-e> <end>

" Control-S Save
nmap <C-S> :w<cr>
vmap <C-S> <esc>:w<cr>
imap <C-S> <esc>:w<cr>

" keep visual selection when (de)indenting
vmap < <gv
vmap > >gv

" move along visual lines, not numbered ones
" without interferring with {count}<down|up>
nnoremap <expr> <Down> (v:count == 0 ? 'g<down>' : '<down>')
vnoremap <expr> <Down> (v:count == 0 ? 'g<down>' : '<down>')
nnoremap <expr> <Up> (v:count == 0 ? 'g<up>' : '<up>')
vnoremap <expr> <Up> (v:count == 0 ? 'g<up>' : '<up>')
nnoremap ^ g^
nnoremap $ g$
vnoremap ^ g^
vnoremap $ g$

" Shortcutting split navigation
" navigage windows from any mode
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" more <C-w> split shortcuts
" <space>-up    - max split height
" <space>-right - max split width
" <space>-left  - normalize split sizes
" <space>-down  - normalize split sizes
" <space>-o     - close all splits but current
" <space>-R     - swap top/bottom or left/right
" <space>-T     - detach current split to a tab
noremap <silent> <C-S-Up> :resize +4<CR>
noremap <silent> <C-S-Down> :resize -4<CR>
noremap <silent> <C-S-Left> :vertical resize -4<CR>
noremap <silent> <C-S-Right> :vertical resize +4<CR>
noremap <silent> <leader><Up> <C-w>_
noremap <silent> <leader><Down> <C-w>=
noremap <silent> <leader><Right> <C-w>\|
noremap <silent> <leader><Left> <C-w>=
noremap <silent> <leader>o <C-w>o
noremap <silent> <leader>R <C-w>R
noremap <silent> <leader>T <C-w>T
noremap <silent> <leader>N :new<CR>


" Tab management
nnoremap <C-Left>           :tabprevious<CR>
nnoremap <C-Right>          :tabnext<CR>
nnoremap <silent> <A-Left>  :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>

" Toggle all buffers into tabs with <Space>-t
let notabs = 0
nnoremap <silent> <Leader>t
  \ :let notabs=!notabs<CR>
  \ :if notabs<CR>:tabo<CR> 
  \ :else<CR>:tab ball<CR>:tabn<CR>
  \ :endif<CR>


" Turn off search matches with double-<Escape>
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" Toggle display of `listchars`
nnoremap <silent> <leader>l <Esc>:set list!<CR><Esc>

" Toggle colored column at 81
nnoremap <silent> <leader>' :execute "set colorcolumn="
                \ . (&colorcolumn == "" ? "81" : "")<CR>


" }}}
"
" {{{ popup menu options (auto-complete)
"

" remap j,k for navigation inside popup menus
" we utilize v:completed_item so we can continue typing
" before any item is selected (before <tab> or arrows were used)
inoremap <expr>j (pumvisible()?(empty(v:completed_item)?'j':"\<C-n>"):'j')
inoremap <expr>k (pumvisible()?(empty(v:completed_item)?'k':"\<C-p>"):'k')

" <Tab> to enter menu and cycle items
inoremap <expr><Tab> (pumvisible()?
  \ (empty(v:completed_item)?"\<C-n>":"\<C-n>"):"\<Tab>")

" <Esc> to close popup menus and delete selection
" <ctrl-c> will revert selection and switch to normal mode
inoremap <expr> <Esc> (pumvisible() ? "\<c-e>" : "\<Esc>")
inoremap <expr> <c-c> (pumvisible() ? "\<c-e>\<c-c>" : "\<c-c>")

" Make up/down arrows behave in completion popups
" without this they move/down but v:completed_item remains empty
inoremap <expr> <down> (pumvisible() ? "\<C-n>" : "\<down>")
inoremap <expr> <up>   (pumvisible() ? "\<C-p>" : "\<up>")

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" <Tab> already mapped above, this mapping from coc is not useful
" as it is cumbersome and prevents tabbing after a word, we keep
" our own <Tab> mapping and use <S-Tab> for coc expand instead
"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ coc#refresh()
inoremap <expr><S-TAB> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif


" }}}
"
" {{{ Plugin Keymaps
"

" Below doesn't work with nvim, we use the suda plugin instead
" Allow saving of files as sudo when I forgot to start vim using sudo.
"cmap w!! w !sudo tee > /dev/null %

" Suda plugin: `w!!` to write as root
cmap w!! w suda://%

" Previm plugin
map <silent> <leader>M <Esc>:PrevimOpen<CR>

" vim-fugitive
map <silent> <leader>uu <Esc>:Git<CR>
map <silent> <leader>ul <Esc>:Git log<CR>
map <silent> <leader>us <Esc>:Git status<CR>
map <silent> <leader>ud <Esc>:Git diff<CR>
map <silent> <leader>uy <Esc>:Git difftool<CR>
map <silent> <leader>ui <Esc>:Git mergetool<CR>
map <silent> <leader>uh <Esc>:Ghdiffsplit<CR>
map <silent> <leader>uv <Esc>:Gvdiffsplit<CR>

" coc-explorer, presets are defined in plugins.vim
map <leader>e :CocCommand explorer<CR>
nmap <leader>nd :CocCommand explorer --preset .nvim<CR>
nmap <leader>nf :CocCommand explorer --preset floating<CR>


" === LeaderF shorcuts === "
"   <leader>;  - Browse currently open buffers in normal mode
"   <leader>fb - Browse currently open (b)uffers in insert mode
"   <leader>w  - Browse files in current (w)orking directory
"   <leader>fm - Browse current (m)arks (output of :marks)
"   <leader>fc - Browse (c)ommand(:) history
"   <leader>fs - Browse (s)earch history
"   <leader>fh - Browse (h)elp terms
"   <leader>fl - Search current file (l)ines
"   <leader>fr - Browse most (r)ecent files
"   <leader>fo - Browse c(o)lor schemes
"   <leader>fi - Search current directory (i)nteractive mode
"   <leader>fe - Search current buffer for (e)xpression
"   <leader>fE - Search current directory for (e)xpression
"   <leader>F  - Search current directory (empty expression)
"   <leader>ff - Reuse previous rg search buffer
"   <leader>fv - Search visually selected text literally
"   <leader>fw - Search word under curosr in current buffer
"   <leader>fW - Search word under curosr in current directory
"   <leader>gg - Search word under curosr in current directory
function! s:Leaderf(target, arg, statusline) abort
  let g:Lf_PopupShowStatusline = a:statusline
  return printf("%s %s", a:target,  a:arg)
endfunction

function! s:LeaderfRg(statusline) abort
  let g:Lf_PopupShowStatusline = a:statusline
  return leaderf#Rg#startCmdline(0, 0, 0, 0)
endfunction

" Override the default keybinds so they don't pollute our binds
" we rebind <leader>ff and <leader>fb> anyways
let g:Lf_ShortcutF = "<leader>ff"
let g:Lf_ShortcutB = "<leader>fb"
noremap <leader>;  :<C-U><C-R>=<SID>Leaderf("Leaderf buffer", "", 0)<CR><CR><Tab>
noremap <leader>fb :<C-U><C-R>=<SID>Leaderf("Leaderf buffer", "", 0)<CR><CR>
noremap <leader>w  :<C-U><C-R>=<SID>Leaderf("Leaderf file", "", 1)<CR><CR><Tab>
noremap <leader>fm :<C-U><C-R>=<SID>Leaderf("Leaderf marks", "", 0)<CR><CR><Tab>
noremap <leader>fc :<C-U><C-R>=<SID>Leaderf("Leaderf cmdHistory", "", 0)<CR><CR>
noremap <leader>fs :<C-U><C-R>=<SID>Leaderf("Leaderf searchHistory", "", 0)<CR><CR>
noremap <leader>fh :<C-U><C-R>=<SID>Leaderf("Leaderf help", "", 0)<CR><CR>
noremap <leader>fl :<C-U><C-R>=<SID>Leaderf("Leaderf line", "", 0)<CR><CR>
noremap <leader>fr :<C-U><C-R>=<SID>Leaderf("Leaderf mru", "", 0)<CR><CR><Tab>
noremap <leader>fo :<C-U><C-R>=<SID>Leaderf("Leaderf colorscheme", "", 0)<CR><CR><Tab>
noremap <leader>fi :<C-U><C-R>=<SID>Leaderf("call leaderf#Rg#Interactive()", "", 1)<CR><CR>
noremap <leader>fe :<C-U><C-R>=<SID>Leaderf("Leaderf rg --current-buffer -e", "", 1)<CR>
noremap <leader>fE :<C-U><C-R>=<SID>Leaderf("Leaderf rg -e", "", 1)<CR>
noremap <leader>F  :<C-U><C-R>=<SID>Leaderf("Leaderf rg", "", 1)<CR><CR>
noremap <leader>ff :<C-U><C-R>=<SID>Leaderf("Leaderf! rg --recall", "", 1)<CR><CR>
noremap <leader>ft :<C-U><C-R>=<SID>Leaderf("Leaderf bufTag", "", 0)<CR><CR>
noremap <leader>fv :<C-U><C-R>=<SID>Leaderf("Leaderf! rg -F -e", leaderf#Rg#visual(), 1)<CR><CR>
noremap <leader>fw :<C-U><C-R>=<SID>Leaderf("Leaderf rg --current-buffer -e", expand("<cword>"), 1)<CR><CR><Tab>
noremap <leader>fW :<C-U><C-R>=<SID>Leaderf("Leaderf rg", expand("<cword>"), 1)<CR><CR>
noremap <leader>gg :<C-U><C-R>=<SID>LeaderfRg(1)<CR><CR>

" rebind <C-j> and <C-k> for preview popup up/down
" unfortuntaely couldn't find a way to do this globally
let g:Lf_NormalMap = {
        \ "_":      [["<C-j>", "<C-Down>"],
        \            ["<C-k>", "<C-Up>"],
        \            ["<C-c>", ":q<CR>"],
        \            ["<Esc>", ":q<CR>"],
        \            [";"    , ":q<CR>"],
        \           ],
        \ "File":   [["<C-k>", ':exec g:Lf_py "fileExplManager._toUpInPopup()"<CR>'],
        \            ["<C-j>", ':exec g:Lf_py "fileExplManager._toDownInPopup()"<CR>'],
        \            ["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']
        \           ],
        \ "Buffer": [["<C-k>", ':exec g:Lf_py "bufExplManager._toUpInPopup()"<CR>'],
        \            ["<C-j>", ':exec g:Lf_py "bufExplManager._toDownInPopup()"<CR>'],
        \            ["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<CR>']
        \           ],
        \ "Mru":    [["<C-k>", ':exec g:Lf_py "mruExplManager._toUpInPopup()"<CR>'],
        \            ["<C-j>", ':exec g:Lf_py "mruExplManager._toDownInPopup()"<CR>'],
        \            ["<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<CR>']
        \           ],
        \ "Rg":     [["<C-k>", ':exec g:Lf_py "rgExplManager._toUpInPopup()"<CR>'],
        \            ["<C-j>", ':exec g:Lf_py "rgExplManager._toDownInPopup()"<CR>'],
        \            ["<ESC>", ':exec g:Lf_py "rgExplManager.quit()"<CR>']
        \           ],
        \ "Line":   [["<C-k>", ':exec g:Lf_py "lineExplManager._toUpInPopup()"<CR>'],
        \            ["<C-j>", ':exec g:Lf_py "lineExplManager._toDownInPopup()"<CR>'],
        \            ["<ESC>", ':exec g:Lf_py "lineExplManager.quit()"<CR>']
        \           ],
        \ "Marks":  [["<Tab>", ':exec g:Lf_py "marksExplManager.input()"<CR>'],
        \            ["<C-k>", ':exec g:Lf_py "marksExplManager._toUpInPopup()"<CR>'],
        \            ["<C-j>", ':exec g:Lf_py "marksExplManager._toDownInPopup()"<CR>'],
        \            ["<ESC>", ':exec g:Lf_py "marksExplManager.quit()"<CR>']
        \           ],
        \}


" === Denite shorcuts === "
"   ;          - Browse currently open buffers in normal mode
"   <leader>rb - Browse currently open buffers in insert mode (filter)
"   <leader>rz - Reuse previous Denite buffer
"   <leader>m  - Browse current marks (output of :marks)
"   <leader>rm - Browse current marks (output of :marks)
"   <leader>j  - Browse current jumplist (output of :jumps)
"   <leader>J  - Browse current changelist (output of :changes)
"   <leader>rj - Browse current jumplist (output of :jumps)
"   <leader>rJ - Browse current changelist (output of :changes)
"   <leader>re - (e)xplore files in current directory
"   <leader>rf - Search current directory for occurences of given term and close window if no results
"   <leader>rg - Search current directory for occurences of word under cursor
"   <leader>rw - Search current directory for occurences of word under cursor
"nmap <silent>;  :Denite buffer<CR>
nmap <leader>rb :Denite buffer<CR>
nmap <leader>rr :Denite -resume<CR>
nmap <leader>m  :Denite mark<CR>
nmap <leader>rm :Denite mark<CR>
nmap <leader>j  :Denite jump<CR>
nmap <leader>J  :Denite change<CR>
nmap <leader>rj :Denite jump<CR>
nmap <leader>rJ :Denite change<CR>
nmap <leader>re :DeniteBufferDir file/rec<CR>
nnoremap <leader>rf :<C-u>Denite grep:. -no-empty<CR>
nnoremap <leader>rg :<C-u>DeniteCursorWord grep:.<CR>
nnoremap <leader>rw :<C-u>DeniteCursorWord grep:.<CR>

" Define mappings while in 'filter' mode
"   <C-o> or <C-c>  - Switch to normal mode inside of search results
"   <Esc>           - Exit denite window in any mode
"   <CR>            - Open currently selected file in any mode
"   <C-t>           - Open currently selected file in a new tab
"   <C-v>           - Open currently selected file a vertical split
"   <C-h>           - Open currently selected file in a horizontal split
augroup DeniteFilter
autocmd!
autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <C-o>
  \ <Plug>(denite_filter_quit)
  imap <silent><buffer> <C-c>
  \ <Plug>(denite_filter_quit)
  imap <silent><buffer> <Tab>
  \ <Plug>(denite_filter_quit)
  inoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  inoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  inoremap <silent><buffer><expr> <C-t>
  \ denite#do_map('do_action', 'tabopen')
  inoremap <silent><buffer><expr> <C-v>
  \ denite#do_map('do_action', 'vsplit')
  inoremap <silent><buffer><expr> <C-h>
  \ denite#do_map('do_action', 'split')
endfunction
augroup END

" Define mappings while in denite window
"   <CR>        - Opens currently selected buffer
"   q or <Esc>  - Quit Denite window
"   i or <C-o>  - Switch to insert mode inside of filter prompt
"   d           - Delete currenly selected buffer
"   p           - Preview currently selected buffer
"   t           - Open currently selected buffer in a new tab
"   v           - Open currently selected buffer in a vertical split
"   b           - Open currently selected buffer in a horizontal split
augroup Denite
autocmd!
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <C-c>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> ;
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> t
  \ denite#do_map('do_action', 'tabopen')
  nnoremap <silent><buffer><expr> v
  \ denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> b
  \ denite#do_map('do_action', 'split')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <C-o>
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Tab>
  \ denite#do_map('open_filter_buffer')
endfunction
augroup END

" === coc.nvim === "
" F12    <leader>cd   - Jump to (d)efinition of current symbol
" S-F12  <leader>cr   - Jump to (r)eferences of current symbol
"        <leader>cy   - Jump to t(y)pedef of current symbol
"        <leader>ci   - Jump to (i)mplementation of current symbol
"        <leader>cR   - (R)ename current word
"        <leader>.    - Code action current line
"        <leader>,    - Autofix current line error
"        <leader>cz   - Code action selected region
"                       ex: `<leader>czap` for current paragraph
"        <leader>cf   - Format selection region
"        <leader>cx   - List all Coc commands
"        <leader>cs   - Fuzzy search current project symbols
"        <leader>cS   - Fuzzy search current document symbols 
"        <leader>ca   - Show all project diagnostics
"        <leader>cc   - Resume last Coc action
"        <leader>C    - Resume last Coc action
"       `[c` | `]c`   - diagnostics next/prev
"        <leader>-/   - show documentation in preview window
"        <leader>-?   - show func signature in preview window
nmap <F12>      <Plug>(coc-definition)
nmap <S-F12>    <Plug>(coc-references)
nmap <leader>cd <Plug>(coc-definition)
nmap <leader>cr <Plug>(coc-references)
nmap <leader>cy <Plug>(coc-type-definition)
nmap <leader>ci  <Plug>(coc-implementation)
nmap <leader>cR <Plug>(coc-rename)
nmap <leader>.  <Plug>(coc-codeaction)
nmap <leader>,  <Plug>(coc-fix-current)
xmap <leader>cz <Plug>(coc-codeaction-selected)
nmap <leader>cz <Plug>(coc-codeaction-selected)
xmap <leader>cf <Plug>(coc-format-selected)
nmap <leader>cf <Plug>(coc-format-selected)
nnoremap <leader>cx :<C-u>CocList -N --normal --top commands<cr>
nnoremap <leader>cs :<C-u>CocList -I -N --top symbols<CR>
nnoremap <leader>cS :<C-u>CocList -N --top outline<cr>
nnoremap <leader>ca :<C-u>CocList -N --top --normal diagnostics<cr>
nnoremap <leader>cc :<C-u>CocListResume<CR>
nnoremap <leader>C  :<C-u>CocListResume<CR>
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nnoremap <leader>? :call CocAction("showSignatureHelp")<CR>
nnoremap <leader>/ :call <SID>show_documentation()<CR>

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
"autocmd CursorHold * silent call CocActionAsync('highlight')

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}


" }}}

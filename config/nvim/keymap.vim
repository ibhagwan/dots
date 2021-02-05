" {{{ Keymaps
"

" map leader as <space>
nnoremap <Space> <nop>
let mapleader ="\<Space>"

" by default `d` is a 'cut' operation into the unnamedplus (+) register
" which in our case is the clipboard, bind <space>d to "real delete" op
" <space>v and <space>s are used to mimc term cmd-v and cmd-s pastes
" <space>p and <space>P paste directly from the yank register (0)
" **Visual mode paste operations delete to blackhole (`"_d` prefix)
" prefix)
" https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text
nnoremap <leader>v "+p
vnoremap <leader>v "_d"+p
nnoremap <leader>s "*p
vnoremap <leader>s "_d"*p
nnoremap <leader>p "0p
vnoremap <leader>p "_d"0p
nnoremap <leader>P "0P
vnoremap <leader>P "_d"0P
" <space>b as a shortcut to the 'blackhole' register
" <space>d|dd|D|x is mapped to "real delete"
nnoremap <leader>b "_
nnoremap <leader>d "_d
nnoremap <leader>D "_D
nnoremap <leader>dd "_dd
nnoremap <leader>x "_x
vnoremap <leader>b "_
vnoremap <leader>d "_d
vnoremap <leader>D "_D
vnoremap <leader>x "_x
" Map `Y` to copy to end of line
" conistent with the behaviour of `C` and `D`
nnoremap Y y$
vnoremap Y <Esc>y$gv

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

" Beginning and end of line in `:` command mode
cmap <C-a> <home>
cmap <C-e> <end>

" Control-S Save
nmap <silent> <C-S> :update<cr>
vmap <silent> <C-S> <esc>:update<cr>
imap <silent> <C-S> <esc>:update<cr>

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
" <C-S-up>      - increase vert size
" <C-S-down>    - decrease vert size
" <C-S-right>   - increase horizontal size
" <C-S-left>    - decrease horizontal size
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

" Navigate thru items in quickfix and location lists
" Borrowed from 'tpope/vim-unimpaired'
nnoremap <silent> ]q :<C-u>cnext<CR>
nnoremap <silent> [q :<C-u>cprev<CR>
nnoremap <silent> ]Q :<C-u>copen<CR>
nnoremap <silent> [Q :<C-u>cclose<CR>
"nnoremap <silent> ]Q :<C-u>clast<CR>
"nnoremap <silent> [Q :<C-u>cfirst<CR>

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

" <Esc> to close popup menus (keeping selection)
" <ctrl-c> will revert selection and switch to normal mode
inoremap <expr> <Esc> (pumvisible() ? "\<c-y>" : "\<Esc>")
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
" :Gedit will always send us back to the working copy
" and thus serves as a quasi back button
map <silent> <leader>gg <Esc>:Gedit<CR>
map <silent> <leader>gs <Esc>:Git<CR>
map <silent> <leader>gl <Esc>:Git log<CR>
map <silent> <leader>gS <Esc>:Git status<CR>
map <silent> <leader>gd <Esc>:Git diff<CR>
map <silent> <leader>gh <Esc>:Ghdiffsplit<CR>
map <silent> <leader>gv <Esc>:Gvdiffsplit<CR>
map <silent> <leader>gH <Esc>:Ghdiffsplit!<CR>
map <silent> <leader>gV <Esc>:Gvdiffsplit!<CR>

" fzf shortcuts
nnoremap <silent> <leader>p  :FzfFiles<CR>
nnoremap <silent> <leader>gf :FzfGFiles<CR>
nnoremap <silent> <leader>;  :FzfBuffers<CR>
nnoremap <silent> <leader>m  :FzfMarks<CR>
nnoremap <silent> <leader>fh :FzfHistory<CR>
nnoremap <silent> <leader>fc :FzfHistory:<CR>
nnoremap <silent> <leader>fs :FzfHistory/<CR>
nnoremap <silent> <leader>fo :FzfColors<CR>
nnoremap <silent> <leader>fx :FzfCommands<CR>
nnoremap <silent> <leader>fl :FzfBLines<CR>
nnoremap <silent> <leader>ft :FzfBTags<CR>
nnoremap <silent> <leader>gc :FzfCommits<CR>
nnoremap <silent> <leader>go :FzfGBranches<CR>
nnoremap <silent> <leader>fq :FzfQf<CR>
nnoremap <silent> <F1> :FzfHelptags<CR>
inoremap <silent> <F1> <ESC>:FzfHelptags<CR>

" https://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript/6271254#6271254
function! s:getVisualSelection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

" custom rg implementation for code files only
let g:rg_command = '
  \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
  \ -g "*.{js,json,php,md,styl,jade,html,config,py,cpp,hpp,c,h,go,hs,rb,conf}"
  \ -g "!*.{min.js,swp,o,zip}" 
  \ -g "!{.git,node_modules,vendor}/*" '
command! -bang -nargs=* FzfRgCustom call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)

" https://github.com/junegunn/fzf.vim#advanced-customization
" FzfRg only starts ripgrep after the query is entered
" the below version delegates all work to ripgrep and
" will restart ripgrep every query modification
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang FzfRG call RipgrepFzf(<q-args>, <bang>0)

" fzf|ripgrep shortcuts
" <leader>fr|r  search using `rg`
" <leader>fw    search word under cursor
" <leader>fv    search visual selection
noremap <leader>r   :<C-U><C-R> FzfRg<Space>
noremap <leader>fr  :<C-U><C-R> FzfRg<Space>
noremap <leader>fR  :<C-U><C-R> FzfRG<Space>
noremap <leader>fw  :<C-U><C-R> FzfRg <C-R><C-W><CR>
noremap <leader>fW  :<C-U><C-R> FzfRg <C-R><C-A><CR>
vnoremap <leader>fv :<C-U><C-R> FzfRg <C-R>=<SID>getVisualSelection()<CR><CR>

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
nmap <leader>cr <Plug>(coc-rename)
nmap <leader>a  <Plug>(coc-codeaction)
nmap <leader>.  <Plug>(coc-fix-current)
xmap <leader>cz <Plug>(coc-codeaction-selected)
nmap <leader>cz <Plug>(coc-codeaction-selected)
xmap <leader>c= <Plug>(coc-format-selected)
nmap <leader>c= <Plug>(coc-format-selected)
xmap <leader>cf <Plug>(coc-format-selected)
noremap <leader>cf  :<C-U><C-R> CocSearch<Space>

" replaced with coc-fzf
" https://github.com/antoinemadec/coc-fzf
"nnoremap <leader>cx :<C-u>CocList -N --normal --top commands<cr>
"nnoremap <leader>cs :<C-u>CocList -I -N --top symbols<CR>
"nnoremap <leader>co :<C-u>CocList -N --top outline<cr>
"nnoremap <leader>cd :<C-u>CocList -N --top --normal diagnostics<cr>
"nnoremap <leader>cc :<C-u>CocListResume<CR>
nnoremap <silent> <space>cc   :<C-u>CocFzfList<CR>
nnoremap <silent> <space>ca   :<C-u>CocFzfList actions<CR>
nnoremap <silent> <space>cd   :<C-u>CocFzfList diagnostics<CR>
nnoremap <silent> <space>cD   :<C-u>CocFzfList diagnostics --current-buf<CR>
nnoremap <silent> <space>cx   :<C-u>CocFzfList commands<CR>
nnoremap <silent> <space>ce   :<C-u>CocFzfList extensions<CR>
nnoremap <silent> <space>cl   :<C-u>CocFzfList location<CR>
nnoremap <silent> <space>co   :<C-u>CocFzfList outline<CR>
nnoremap <silent> <space>cs   :<C-u>CocFzfList symbols<CR>
nnoremap <silent> <space>cc   :<C-u>CocFzfListResume<CR>

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

" coc-explorer, presets are defined in plugins.vim
map <leader>e :CocCommand explorer<CR>
nmap <leader>nd :CocCommand explorer --preset .nvim<CR>
nmap <leader>nf :CocCommand explorer --preset floating<CR>

" }}}

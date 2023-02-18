#!/bin/sh

# Configure fzf, command line fuzzy finder
#
# Keybinds:
# F3        - Toggle preview word wrap
# F4        - Toggle preview
# <ctrl-f>  - Scroll page down
# <ctrl-b>  - Scroll page up
# <shift-d> - Preview page down
# <shift-u> - Preview page up
# <alt-d>   - Preview half page down
# <alt-u>   - Preview half page up
# <alt-a>   - Toggle select-all
# <ctrl-x>  - Delete selected files
# <ctrl-y>  - Copy path to clipboard (requires xclip)
FZF_OPTS="--no-mouse --height=50%  --layout=reverse --multi --delimiter='[ :]'"
FZF_BINDS="f3:toggle-preview-wrap,f4:toggle-preview,shift-down:preview-page-down,shift-up:preview-page-up,alt-down:preview-half-page-down,alt-up:preview-half-page-up,ctrl-u:unix-line-discard,ctrl-f:half-page-down,ctrl-b:half-page-up,ctrl-a:beginning-of-line,ctrl-e:end-of-line,alt-a:toggle-all,ctrl-y:execute-silent(echo {+} | xclip -selection clipboard),ctrl-x:execute(rm -i {+})+abort"
FZF_PREVIEW_OPTS="hidden:border:nowrap,right:60%"
FZF_CTRL_R_OPTS="--no-separator --info=inline"
# FZF_CTRL_T_OPTS="--no-separator --info=inline"

# Use fzf inside tmux popup if possible
if [ -n $TMUX ]; then
  export FZF_TMUX_OPTS="-p80%,60% -- --margin=0,0"
  export FZF_CTRL_T_OPTS="${FZF_CTRL_T_OPTS} --preview-window=nohidden"
fi

# use `bat` for preview if installed, `head` otherwise
# https://github.com/sharkdp/bat
if command -v bat > /dev/null 2>&1; then
  FZF_PREVIEW_CMD="bat --style=numbers --color=always {} || ls -la {}"
  # bat options
  # for list of themes `bat --list-themes`
  export BAT_PAGER="less -R"
  export BAT_THEME="1337"
else
  FZF_PREVIEW_CMD="head -n FZF_PREVIEW_LINES {} || ls -la {}"
fi

# construct ${FZF_DEFAULT_OPTS}
export FZF_DEFAULT_OPTS="$FZF_OPTS --bind='$FZF_BINDS' --preview-window='$FZF_PREVIEW_OPTS' --preview='$FZF_PREVIEW_CMD'"

# use `rg` if installed
# https://github.com/BurntSushi/ripgrep
if command -v rg > /dev/null 2>&1; then
  RG_OPTS="--files --no-ignore --hidden --follow -g '!{.git,node_modules}/*' 2> /dev/null"
  export FZF_DEFAULT_COMMAND="rg $RG_OPTS"
  export FZF_CTRL_T_COMMAND="rg $RG_OPTS"
fi

# use `fd` if installed
# https://github.com/sharkdp/fd
if command -v fd > /dev/null 2>&1; then
  FD_OPTS="--hidden --follow --exclude .git --exclude node_modules"
  export FZF_DEFAULT_COMMAND="fd --strip-cwd-prefix --type f --type l $FD_OPTS"
  export FZF_CTRL_T_COMMAND="fd --strip-cwd-prefix $FD_OPTS"
  export FZF_ALT_C_COMMAND="fd --type d $FD_OPTS"
  # export FZF_ALT_C_COMMAND="fd --type d $FD_OPTS . ~"
fi

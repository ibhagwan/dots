#!/bin/sh

# Configure fzf/skim
#
# Keybinds:
# F3             - Toggle preview word wrap
# F4             - Toggle preview
# <ctrl-f>       - Scroll page down
# <ctrl-b>       - Scroll page up
# <shift-d>      - Preview page down
# <shift-u>      - Preview page up
# <alt-shift-d>  - Preview scroll down
# <alt-shift-u>  - Preview scroll up
# <alt-a>        - Toggle select-all
# <ctrl-y>       - Copy path to clipboard (requires xclip)
FZF_OPTS="--no-mouse --layout=reverse --height=50% --multi"
FZF_BINDS="f3:toggle-preview-wrap,f4:toggle-preview,shift-down:preview-page-down,shift-up:preview-page-up,alt-shift-down:preview-down,alt-shift-up:preview-up,ctrl-u:unix-line-discard,ctrl-f:half-page-down,ctrl-b:half-page-up,alt-a:toggle-all,alt-g:first,alt-G:last,ctrl-y:execute-silent(echo {+} | xclip -selection clipboard)"
FZF_PREVIEW_OPTS="hidden:border:nowrap,right:60%"
export FZF_CTRL_R_OPTS="--no-separator --info=inline"
export FZF_ALT_C_OPTS="--no-separator --info=inline"

# Use fzf inside tmux popup if possible
if [ ! -z ${TMUX+x} ]; then
  # export FZF_TMUX_OPTS="-p80%,60% -- --margin=0,0"
  export FZF_TMUX_OPTS=
  export FZF_ALT_C_OPTS="--tmux 70%:70% --preview-window=hidden"
  export FZF_CTRL_T_OPTS="--tmux 90%:70% ${FZF_CTRL_T_OPTS} --preview-window=nohidden"
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
export FZF_DEFAULT_OPTS="$FZF_OPTS --info=inline-right --bind='$FZF_BINDS' --preview-window='$FZF_PREVIEW_OPTS' --preview='$FZF_PREVIEW_CMD'"

# use `rg` if installed
# https://github.com/BurntSushi/ripgrep
if command -v rg > /dev/null 2>&1; then
  RG_OPTS='--files --hidden --follow -g "!{.git,node_modules}/*"'
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

# Use similar fzf flags with skim
export SKIM_DEFAULT_COMMAND="${FZF_DEFAULT_COMMAND}"
export SKIM_DEFAULT_OPTIONS="$FZF_OPTS --info=inline --bind='$FZF_BINDS' --preview-window='$FZF_PREVIEW_OPTS' --preview='$FZF_PREVIEW_CMD'"

# https://github.com/dandavison/delta
if command -v delta > /dev/null 2>&1; then
  export FZF_GIT_PAGER="delta"
fi

# ctrl-t .gitignore toggle
# https://github.com/junegunn/fzf/issues/3354

CTRL_G="\x1b[0;34m<ctrl-g>\x1b[0m"

# Bash concatenates string literals that are adjacent
# spaces inside of backticks evaluate to nothing
export FZF_CTRL_T_OPTS="${FZF_CTRL_T_OPTS} "`
    `"--prompt 'restricted> ' "`
    `"--bind 'start:transform-header:echo \":: ${CTRL_G} to disable .gitignore\"' "`
    `"--bind 'ctrl-g:transform:[[ ! \$FZF_PROMPT =~ unrestricted ]] && "`
        `"echo \"rebind(ctrl-g)+change-prompt(unrestricted> )"`
            `"+change-header(:: ${CTRL_G} to respect .gitignore)"`
            `"+reload($FZF_CTRL_T_COMMAND --no-ignore)\""`
    `" || "`
        `"echo \"rebind(ctrl-g)+change-prompt(restricted> )"`
            `"+change-header(:: ${CTRL_G} to disable .gitignore)"`
            `"+reload($FZF_CTRL_T_COMMAND)\"'"

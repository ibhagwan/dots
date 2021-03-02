# Enable colors and change prompt:
autoload -U colors && colors
case `id -u` in
0) prompt="#";;
*) prompt="$";;
esac
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}${prompt}%b "

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# tmux messes up LS colors, reset to default
[[ ! -z $TMUX ]] && unset LS_COLORS

# make the cache directory if needed
[ ! -d "$HOME/.cache/zsh" ] && mkdir -p "$HOME/.cache/zsh"

# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"
[ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"

# Use zcalc
autoload -U zcalc

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode (the equivalent of `set -o vi`)
bindkey -v

# set 1ms timeout for Esc press so we can switch
# between vi "normal" and "command" modes faster
export KEYTIMEOUT=1

# Use vim keys in tab complete menu (2nd tab press):
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# by default backspace (^?) is bound to `vi-backward-delete-char`
# we want it to have the same bahvior as vim/nvim (i.e. backspace=del)
# without the below we will get stuck unable to backspace after Esc-k-A
bindkey -v '^?' backward-delete-char

# Better searching in vi command mode
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward
bindkey -M viins '^k' history-incremental-search-backward
bindkey -M viins '^j' history-incremental-search-forward

# Change cursor shape for different vi modes.
# block cursor for cmd mode, line (beam) otherwise
#  1 -> blinking block
#  2 -> solid block 
#  3 -> blinking underscore
#  4 -> solid underscore
#  5 -> blinking vertical bar
#  6 -> solid vertical bar
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.


# Use vifm to switch directories and bind it to ctrl-f
vifmcd () {
    tmp="$(mktemp)"
    vifm --choose-dir="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^f' 'vifmcd\r'


# Edit line in $EDITOR with ctrl-e
# similar to Esc-v in `set -o vi`
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd 'v' edit-command-line

# CTRL-Z as shortcut for `$ fg`
bindkey -s '^z' 'fg\r'

# Load zsh-syntax-highlighting; should be last.
#source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# fzf (https://github.com/junegunn/fzf)
# if installed enable fzf keybinds
[ -f /usr/share/doc/fzf/completion.zsh ] && source /usr/share/doc/fzf/completion.zsh
[ -f /usr/share/doc/fzf/key-bindings.zsh ] && source /usr/share/doc/fzf/key-bindings.zsh
# Arch linux paths
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
# OSX paths
[ -f /usr/local/opt/fzf/shell/completion.zsh ] && source /usr/local/opt/fzf/shell/completion.zsh
[ -f /usr/local/opt/fzf/shell/key-bindings.zsh ] && source /usr/local/opt/fzf/shell/key-bindings.zsh

# totp command complettion (`pip install totp)
# https://pypi.org/project/totp/
# https://github.com/WhyNotHugo/totp-cli/blob/master/contrib/totp-cli-completion.zsh
# 
#[ -f ~/.config/zsh/totp-cli-completion.zsh ] && source ~/.config/zsh/totp-cli-completion.zsh
# The above doesn't work, instead copy the file as `_totp` to:
# `/usr/share/zsh/functions/Completion/Zsh/_totp`

# Don't use an yplugins for root
if [ "$EUID" -ne 0 ]; then

# antigen plugin manager
# https://github.com/zsh-users/antigen
# Install nightly version to workaround the $ADOTDIR bug:
# `curl -L git.io/antigen-nightly > antigen.zsh`
source ~/.config/zsh/antigen.zsh

# Syntax highlighting bundle.
#antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zdharma/fast-syntax-highlighting

# Pure prompt
#antigen bundle mafredri/zsh-async
#antigen bundle sindresorhus/pure

# Spaceship prompt options:
# https://github.com/denysdovhan/spaceship-prompt/blob/master/docs/Options.md
# the below swaps the order of host<->dir, couldn't find a shorter way...
SPACESHIP_PROMPT_ORDER=(
  time          # Time stamps section
  user          # Username section
  host          # Hostname section
  dir           # Current directory section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  package       # Package version
  node          # Node.js section
  ruby          # Ruby section
  elixir        # Elixir section
  xcode         # Xcode section
  swift         # Swift section
  golang        # Go section
  php           # PHP section
  rust          # Rust section
  haskell       # Haskell Stack section
  julia         # Julia section
  docker        # Docker section
  aws           # Amazon Web Services section
  venv          # virtualenv section
  conda         # conda virtualenv section
  pyenv         # Pyenv section
  dotnet        # .NET section
  ember         # Ember.js section
  kubectl       # Kubectl context section
  terraform     # Terraform workspace section
  exec_time     # Execution time
  line_sep      # Line break
  battery       # Battery level and status
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_PROMPT_DEFAULT_SUFFIX=' '   # space as defeault separator
SPACESHIP_CHAR_SYMBOL='❯'             # pure prompt character
SPACESHIP_CHAR_SUFFIX=' '
SPACESHIP_USER_SUFFIX=''
SPACESHIP_HOST_PREFIX='@'
SPACESHIP_DIR_PREFIX=''
SPACESHIP_GIT_PREFIX=''
SPACESHIP_USER_SHOW=true              # 'always' if you want username outside of ssh
SPACESHIP_HOST_SHOW=true              # 'always' if you want hostname outside of ssh
SPACESHIP_VI_MODE_SHOW=false          # don't need this, zle-keymap-select is enough
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=false

# set the prompt theme to spaceship
antigen theme denysdovhan/spaceship-prompt

# We're done antigen!
antigen apply

fi # if [ "$EUID" -ne 0 ]; then

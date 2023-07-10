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

# Load aliases and if exists.
[ -f "$HOME/.config/aliases/public" ] && source "$HOME/.config/aliases/public"
[ -f "$HOME/.config/aliases/private" ] && source "$HOME/.config/aliases/private"

# add yadm completions to path, must be done before compinit
[ -d "$HOME/dots/yadm" ] && fpath=($HOME/dots/yadm/completion/zsh $fpath)

# Use zcalc
autoload -U zcalc

# Basic auto/tab complete:
autoload -U +X compinit
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
# disabled due to bad interaction with nvim-neoterm
#bindkey -M viins '^k' history-incremental-search-backward
#bindkey -M viins '^j' history-incremental-search-forward

# Change cursor shape for different vi modes.
# block cursor for cmd mode, line (beam) otherwise
#  1 -> blinking block
#  2 -> solid block 
#  3 -> blinking underscore
#  4 -> solid underscore
#  5 -> blinking vertical bar
#  6 -> solid vertical bar
# source: https://github.com/ohmyzsh/ohmyzsh/issues/9570
function zle-keymap-select {
  # https://vt100.net/docs/vt510-rm/DECSCUSR
  local _shape=0
  # $KEYMAP contains the new mode
  # $VI_KEYMAP contains the current mode
  # case "${1:-${VI_KEYMAP:-main}}" in
  case "${KEYMAP:-main}" in
    main)    _shape=5 ;; # vi insert: line
    viins)   _shape=5 ;; # vi insert: line
    isearch) _shape=6 ;; # inc search: line
    command) _shape=6 ;; # read a command name
    vicmd)   _shape=2 ;; # vi cmd: block
    visual)  _shape=2 ;; # vi visual mode: block
    viopp)   _shape=0 ;; # vi operation pending: blinking block
    *)       _shape=0 ;;
  esac
  printf $'\e[%d q' "${_shape}"
}
zle -N zle-keymap-select
# https://superuser.com/questions/685005/tmux-in-zsh-with-vi-mode-toggle-cursor-shape-between-normal-and-insert-mode
_set_beam_cursor() { echo -ne '\e[5 q' }
# ensure beam cursor when starting new terminal
precmd_functions+=(_set_beam_cursor)
# ensure insert mode and beam cursor when exiting vim
zle-line-init() { zle -K viins; _set_beam_cursor }
zle -N zle-line-init

# launch a process and detach from 'bg'
# complete as if we're running `exec`
function launch {
    nohup "$@" >/dev/null 2>/dev/null & disown
}
# https://github.com/zsh-users/antigen/issues/701
# https://unix.stackexchange.com/questions/670676/zsh-autocompletion-for-function-based-on-git-why-is-compdef-not-working-in-zsh
# autoload -U +X compinit && compinit
# compdef launch=exec
compdef $_comps[exec] launch


# hex<->dec conversion
# use `python` if installed due to handling of big int
hex2dec() {
    if command -v python > /dev/null 2>&1; then
        python -c "print(int(\"${1}\", 16))"
    else
        printf "%d\n" ${1}
    fi
}
dec2hex() {
    if command -v python > /dev/null 2>&1; then
        python -c "print(hex(${1}));"
    else
        printf "%x\n" ${1}
    fi
}


# zoxide - smarter cd
# https://github.com/ajeetdsouza/zoxide
if command -v zoxide > /dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# Use vifm to switch directories and bind it to ctrl-f
# not using this anymore, ripgrep stole the bind
vifmcd () {
    tmp="$(mktemp)"
    vifm --choose-dir="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
#bindkey -s '^f' 'vifcmd\r'

# Edit line in $EDITOR with ctrl-e
# similar to Esc-v in `set -o vi`
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd 'v' edit-command-line

# CTRL-Z as shortcut for `$ fg`
# bindkey -s '^z' '^[ddifg\r'
function fg-bg {
    if [[ $#BUFFER -eq 0 ]]; then
        BUFFER=fg
        zle accept-line
    else
        zle push-input
    fi
}
zle -N fg-bg
bindkey '^z' fg-bg

# Load zsh-syntax-highlighting; should be last.
#source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# fzf (https://github.com/junegunn/fzf)
# if installed enable fzf keybinds
for dir in "/usr/share/fzf" "/usr/local/share/fzf" "/usr/share/doc/fzf" \
    "/usr/local/opt/fzf" "/opt/homebrew/opt/fzf" "$HOME/rootfs/share/fzf/shell"
do
    [ -f ${dir}/completion.zsh ] && source "${dir}/completion.zsh"
    [ -f ${dir}/key-bindings.zsh ] && source "${dir}/key-bindings.zsh"
done

# Fzf commands for git, need to unbind ^G or we conflict
#   ^G^F    git ls-files
#   ^G^B    git branches
#   ^G^S    git status
#   ^G^C    git commits
#   ^G^T    git tags
#   ^G^R    git remotes
# ^Y set is equal for yadm bare repo
# ^F for generic "live" ripgrep
source $ZDOTDIR/fzf_defaults.sh
source $ZDOTDIR/fzf_git_functions.sh
source $ZDOTDIR/fzf_git_keybindings.zsh
FZF_GIT_CMD="git -c status.showUntrackedFiles=no -C $HOME --work-tree=$HOME --git-dir=$YADM_REPO" \
    FZF_ZLE_PREFIX="fzf-yadm" FZF_GIT_BIND="^Y" \
    source $ZDOTDIR/fzf_git_keybindings.zsh

# totp command complettion (`pip install totp)
# https://pypi.org/project/totp/
# https://github.com/WhyNotHugo/totp-cli/blob/master/contrib/totp-cli-completion.zsh
# 
#[ -f ~/.config/zsh/totp-cli-completion.zsh ] && source ~/.config/zsh/totp-cli-completion.zsh
# The above doesn't work, instead copy the file as `_totp` to:
# `/usr/share/zsh/functions/Completion/Zsh/_totp`

# Don't use an yplugins for root
if [ "$EUID" -ne 0 ]; then

# do we have starship.rs prompt installed?
if command -v starship > /dev/null 2>&1; then
    HAS_STARSHIP=true
    eval "$(starship init zsh)"
else
    HAS_STARSHIP=false
fi

# https://github.com/mattmc3/antidote
if [ ! -d ${ZDOTDIR:-~}/.antidote ]; then
    git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
fi

# source antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# https://getantidote.github.io/migrating-from-antigen
# Initialize antidote's dynamic mode, which changes `antidote bundle`
# from static mode (instead of `antidote load` & .zsh_plugins.txt).
source <(antidote init)

# Syntax highlighting bundle.
antidote bundle zdharma-continuum/fast-syntax-highlighting

# set the prompt theme to spaceship-prompt
# if we don't have starship binary installed
# spaceship-prompt configuration
if [ $HAS_STARSHIP = false ]; then
    export SPACESHIP_CONFIG="${ZDOTDIR}/spaceship.zsh"
    antidote bundle "spaceship-prompt/spaceship-prompt"
    # antidote bundle "spaceship-prompt/spaceship-vi-mode@main"
fi

fi # if [ "$EUID" -ne 0 ]; then

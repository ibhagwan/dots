# $OpenBSD: dot.profile,v 1.5 2018/02/02 02:29:54 yasuoka Exp $
#
# sh/ksh initialization

PATH=/usr/lib/ccache/bin:$HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/opt/X11/bin:/opt/local/bin:$HOME/.local/bin:$HOME/.config/coc/extensions/coc-lua-data/tools/bin
export PATH HOME TERM

# golang variables
export GOROOT=/usr/lib/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# use nvim if installed, vi default
case "$(command -v nvim)" in
  */nvim) VIM=nvim ;;
  *)      VIM=vi   ;;
esac

export EDITOR=$VIM
export FCEDIT=$EDITOR
export PAGER=less
export LESS='-iMRS -x2'
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

#export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_STYLE_OVERRIDE=adwaita-dark
#export GTK2_RC_FILES=/usr/share/themes/AdwaitaDark/gtk-2.0/gtkrc

# prevent less from saving history in ~/.lesshst
#export LESSHISTFILE="-"
export LESSHISTFILE=/dev/null

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
#export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority" # This line will break some DMs.
export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc-2.0"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/inputrc"
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
#export ALSA_CONFIG_PATH="$XDG_CONFIG_HOME/alsa/asoundrc"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
#export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"

# Prevent launching `at-spi-bus-launcher|at-spi2-registryd`
export NO_AT_BRIDGE=1

# Configure fzf, command line fuzzyf finder
# https://github.com/samoshkin/dotfiles/blob/master/variables.sh
#
# Keybinds:
# F2        - Preview file (right side pane)
# F3        - Preview file (full screen)
# F4        - Edit with $EDITOR
# <ctrl-f>  - Scroll page down
# <ctrl-b>  - Scroll page up
# <ctrl-d>  - Scroll half page down
# <ctrl-u>  - Scroll half page up
# <ctrl-a>  - Select all and accept (enter)
# <ctrl-y>  - Copy path to clipboard (requires xclip)
# <ctrl-x>  - Delete selected files
# 
# use `bat` for preview if installed
if [ -x /usr/bin/bat ]; then
  export FZF_DEFAULT_OPTS="--no-mouse --height 50% -1 --reverse --multi --inline-info --preview='[[ \$(file --dereference --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:hidden:nowrap' --bind='f4:execute($EDITOR {}),f3:execute(bat --style=numbers {} || less -f {}),f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-f:page-down,ctrl-b:page-up,ctrl-a:toggle-all,ctrl-y:execute-silent(echo {+} | xclip -selection clipboard),ctrl-x:execute(rm -i {+})+abort',ctrl-w:toggle-preview-wrap,ctrl-l:clear-query"
else
  export FZF_DEFAULT_OPTS="--no-mouse --height 50% -1 --reverse --multi --inline-info --bind='f4:execute($EDITOR {}),f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-f:page-down,ctrl-b:page-up,ctrl-a:toggle-all,ctrl-y:execute-silent(echo {+} | xclip -selection clipboard),ctrl-x:execute(rm -i {+})+abort',ctrl-w:toggle-preview-wrap,ctrl-l:clear-query"
fi

# Use git-ls-files inside git repo, otherwise rg
# https://github.com/BurntSushi/ripgrep
if [ -x /usr/bin/rg ]; then
  RG_OPTS="--files --no-ignore --hidden --follow -g '!{.git,node_modules}/*' 2> /dev/null"
  export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard || rg $RG_OPTS"
  export FZF_CTRL_T_COMMAND="rg $RG_OPTS"
fi

# use `fd` if installed
# https://github.com/sharkdp/fd
if [ -x /usr/bin/fd ]; then
  FD_OPTS="--hidden --follow --exclude .git --exclude node_modules"
  export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard || fd --type f --type l $FD_OPTS"
  export FZF_CTRL_T_COMMAND="fd $FD_OPTS"
  export FZF_ALT_C_COMMAND="fd --type d $FD_OPTS . ~"
  #export FZF_ALT_C_COMMAND="fd --type d $FD_OPTS"
fi

# bat options
# https://github.com/sharkdp/bat
# for list of themes `bat --list-themes`
export BAT_PAGER="less -R"
export BAT_THEME="Monokai Extended"


# ksh
if [ ! -z "$KSH_VERSION" ]; then
  export ENV=$HOME/.kshrc
fi
#[[ ! -z "$KSH_VERSION" ]] && export ENV=$HOME/.kshrc

# zsh will look for .zshrc here
export ZDOTDIR="$HOME/.config/zsh"

# gnupg keystore
export GNUPGHOME="$HOME/.config/gnupg"

# pass folder
export PASSWORD_STORE_DIR="$HOME/.config/password_store"

# vimgolf setup
# original ruby client:
# https://github.com/igrigorik/vimgolf
export GOLFVIM=nvim
# alternative python client:
# `$ pip3 install vimgolf`
# https://github.com/dstein64/vimgolf
export GOLF_VIM=nvim


# workaround for Wasabi-Wallet
# https://github.com/zkSNACKs/WalletWasabi/issues/1223
# SSL version should match output of:
# ❯ xbps-query -l | grep libssl
export CLR_OPENSSL_VERSION_OVERRIDE=48

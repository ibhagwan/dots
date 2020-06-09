# $OpenBSD: dot.profile,v 1.5 2018/02/02 02:29:54 yasuoka Exp $
#
# sh/ksh initialization

PATH=/usr/lib/ccache/bin:$HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/opt/X11/bin:/opt/local/bin:$HOME/.local/bin:$HOME/.config/coc/extensions/coc-lua-data/tools/bin:$HOME/.gem/ruby/2.7.0/bin
export PATH HOME TERM

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

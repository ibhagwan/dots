# $OpenBSD: dot.profile,v 1.5 2018/02/02 02:29:54 yasuoka Exp $
#
PATH=/usr/lib/ccache/bin:$HOME/bin:/opt/homebrew/bin:/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/opt/X11/bin:/opt/local/bin:$HOME/.local/bin:$HOME/.cargo/bin
MANPATH=/usr/share/man:/usr/local/share/man:/opt/homebrew/share/man
export PATH MANPATH HOME TERM


# use nvim if installed, vi default
case "$(command -v nvim)" in
  */nvim) VIM=nvim ;;
  *)      VIM=vi   ;;
esac

# use neovim as man pager
if [ $VIM = "nvim" ]; then
    export MANPAGER='nvim +Man!'
    export MANWIDTH=999
fi

export EDITOR=$VIM
export FCEDIT=$EDITOR
export PAGER=less
export LESS='-iMRS -x2'
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# for some reason this gets set over ssh
# and messes up the colors
unset LS_COLORS

# prevent less from saving history in ~/.lesshst
export LESSHISTFILE=/dev/null

# Void linux without eologind doesn't have $XDG_RUNTIME_DIR defined
# if '/run/user/USER_ID' doesn't exist, create our runtime under /tmp
if [ -z "$XDG_RUNTIME_DIR" ] && [ -d /run/user/$(id -u) ]; then
    export XDG_RUNTIME_DIR=/run/user/$(id -u)
fi
if [ -z "$XDG_RUNTIME_DIR" ]; then
    mkdir -p /tmp/${USER}-runtime && chmod -R 0700 /tmp/${USER}-runtime
    export XDG_RUNTIME_DIR=/tmp/${USER}-runtime
fi

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/inputrc"
export TMUX_TMPDIR="${XDG_RUNTIME_DIR}"
export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc-2.0"

#export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_STYLE_OVERRIDE=adwaita-dark

# zsh will look for .zshrc here
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# yadm dotfile repo
export YADM_REPO="$HOME/dots/yadm-repo"

# starship prompt config
export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship/starship.toml"

# gnupg keystore
export GNUPGHOME="${XDG_CONFIG_HOME:-$HOME/.config}/gnupg"

# pass folder
export PASSWORD_STORE_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/password_store"

# golang variables, test for '/usr/lib/golang' first
[ -d "/usr/lib/golang" ] && export GOROOT=/usr/lib/golang
[ -z "$GOROOT" ] && export GOROOT=/usr/lib/go
export GOPATH="$HOME/.go"
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
#export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"

# rust backtrace by default
export RUST_BACKTRACE=1

# Prevent launching `at-spi-bus-launcher|at-spi2-registryd`
export NO_AT_BRIDGE=1

# vimgolf setup
# original ruby client:
# https://github.com/igrigorik/vimgolf
export GOLFVIM=/shared/$USER/Applications/nvim-v044/nvim.appimage
# alternative python client:
# `$ pip3 install vimgolf`
# https://github.com/dstein64/vimgolf
export GOLF_VIM=/shared/$USER/Applications/nvim-v044/nvim.appimage

# workaround for Wasabi-Wallet
# https://github.com/zkSNACKs/WalletWasabi/issues/1223
# SSL version should match output of:
# ❯ xbps-query -l | grep libssl
export CLR_OPENSSL_VERSION_OVERRIDE=48

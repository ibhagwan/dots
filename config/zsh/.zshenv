# .zshenv must be in the home directory
# thus it is the one setting the $ZDOTDIR
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# antigen plugin manager cache
# https://github.com/zsh-users/antigen/wiki/Configuration
export ADOTDIR="$HOME/.config/antigen"

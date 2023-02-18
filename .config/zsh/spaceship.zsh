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
  #pyenv         # Pyenv section
  dotnet        # .NET section
  #ember         # Ember.js section
  kubectl       # Kubectl context section
  terraform     # Terraform workspace section
  exec_time     # Execution time
  line_sep      # Line break
  battery       # Battery level and status
  #vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  # async         # Async job mode indicator
  char          # Prompt character
)

SPACESHIP_ASYNC_SHOW_COUNT=true
SPACESHIP_PROMPT_DEFAULT_SUFFIX=' '   # space as defeault separator
SPACESHIP_CHAR_SYMBOL='❯'             # pure prompt character
SPACESHIP_CHAR_SUFFIX=' '
SPACESHIP_USER_SUFFIX=''
SPACESHIP_HOST_PREFIX='@'
SPACESHIP_DIR_PREFIX=''
# async is bugged ATM:
# https://github.com/spaceship-prompt/spaceship-prompt/issues/1193
# SPACESHIP_PROMPT_ASYNC=false          # FIX: bugged, won't show on async
SPACESHIP_GIT_ASYNC=false             # FIX: bugged, won't show on async
SPACESHIP_GIT_PREFIX=''
SPACESHIP_USER_SHOW=true              # 'always' if you want username outside of ssh
SPACESHIP_HOST_SHOW=true              # 'always' if you want hostname outside of ssh
SPACESHIP_VI_MODE_SHOW=false          # don't need this, zle-keymap-select is enough
SPACESHIP_VI_MODE_INSERT='[I]'
SPACESHIP_VI_MODE_NORMAL='[N]'
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=false
# SPACESHIP_PACKAGE_SYMBOL=' '
# SPACESHIP_RUST_SYMBOL=' '
# SPACESHIP_RUST_SYMBOL=' '
# SPACESHIP_GOLANG_SYMBOL=' '
# SPACESHIP_GOLANG_SYMBOL='ﳑ '
SPACESHIP_PACKAGE_SYMBOL=' '
SPACESHIP_GOLANG_SYMBOL=' '
SPACESHIP_RUST_SYMBOL='ﳒ '
SPACESHIP_RUBY_SYMBOL=' '
# SPACESHIP_PHP_SYMBOL='ﳄ '
SPACESHIP_PHP_SYMBOL=' '

# https://github.com/spaceship-prompt/spaceship-vi-mode#helpers
# eval spaceship_vi_mode_enable

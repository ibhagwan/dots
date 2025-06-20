# Spaceship prompt options:
# https://github.com/spaceship-prompt/spaceship-prompt/blob/master/docs/config/prompt.md
# the below swaps the order of host<->dir, couldn't find a shorter way...
SPACESHIP_PROMPT_ORDER=(
  time           # Time stamps section
  user           # Username section
  host           # Hostname section
  dir            # Current directory section
  git            # Git section (git_branch + git_status)
  hg             # Mercurial section (hg_branch  + hg_status)
  package        # Package version
  node           # Node.js section
  bun            # Bun section
  deno           # Deno section
  ruby           # Ruby section
  python         # Python section
  elm            # Elm section
  elixir         # Elixir section
  xcode          # Xcode section
  xcenv          # xcenv section
  swift          # Swift section
  swiftenv       # swiftenv section
  golang         # Go section
  perl           # Perl section
  php            # PHP section
  rust           # Rust section
  haskell        # Haskell Stack section
  scala          # Scala section
  kotlin         # Kotlin section
  java           # Java section
  lua            # Lua section
  dart           # Dart section
  julia          # Julia section
  crystal        # Crystal section
  docker         # Docker section
  docker_compose # Docker section
  aws            # Amazon Web Services section
  gcloud         # Google Cloud Platform section
  azure          # Azure section
  venv           # virtualenv section
  conda          # conda virtualenv section
  uv             # uv section
  dotnet         # .NET section
  ocaml          # OCaml section
  vlang          # V section
  zig            # Zig section
  purescript     # PureScript section
  erlang         # Erlang section
  gleam          # Gleam section
  kubectl        # Kubectl context section
  ansible        # Ansible section
  terraform      # Terraform workspace section
  pulumi         # Pulumi stack section
  ibmcloud       # IBM Cloud section
  nix_shell      # Nix shell
  gnu_screen     # GNU Screen section
  exec_time      # Execution time
  async          # Async jobs indicator
  line_sep       # Line break
  battery        # Battery level and status
  jobs           # Background jobs indicator
  exit_code      # Exit code section
  sudo           # Sudo indicator
  char           # Prompt character
)

# https://github.com/spaceship-prompt/spaceship-prompt/issues/1193
# SPACESHIP_PROMPT_ASYNC=false
# SPACESHIP_ASYNC_SHOW_COUNT=true
# SPACESHIP_PROMPT_DEFAULT_SUFFIX=' '   # space as defeault separator
# SPACESHIP_CHAR_SYMBOL='❯'             # pure prompt character
# SPACESHIP_CHAR_SUFFIX=' '
SPACESHIP_USER_SUFFIX=''
SPACESHIP_HOST_PREFIX='@'
SPACESHIP_DIR_PREFIX=''
SPACESHIP_DIR_TRUNC=2
# SPACESHIP_USER_SHOW=true              # 'always' if you want username outside of ssh
# SPACESHIP_HOST_SHOW=true              # 'always' if you want hostname outside of ssh
# SPACESHIP_VI_MODE_SHOW=true
# SPACESHIP_VI_MODE_INSERT='[I]'
# SPACESHIP_VI_MODE_NORMAL='[N]'
# SPACESHIP_PROMPT_ADD_NEWLINE=false
# SPACESHIP_PROMPT_SEPARATE_LINE=false
# SPACESHIP_PACKAGE_SYMBOL=' '
# SPACESHIP_RUST_SYMBOL=' '
# SPACESHIP_RUST_SYMBOL=' '
# SPACESHIP_GOLANG_SYMBOL=' '
# SPACESHIP_GOLANG_SYMBOL='ﳑ '
# SPACESHIP_PACKAGE_SYMBOL=' '
# SPACESHIP_GOLANG_SYMBOL=' '
# SPACESHIP_RUST_SYMBOL='ﳒ '
# SPACESHIP_RUBY_SYMBOL=' '
# # SPACESHIP_PHP_SYMBOL='ﳄ '
# SPACESHIP_PHP_SYMBOL=' '

# https://github.com/spaceship-prompt/spaceship-vi-mode#helpers
# eval spaceship add --after line_sep vi_mode

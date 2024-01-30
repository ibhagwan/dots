# GIT heart FZF
# -------------

is_in_git_repo() {
  $@ rev-parse HEAD > /dev/null 2>&1
  # $@ rev-parse HEAD > /dev/null 2>&1 || true
}

fzf-exec() {
  if [ -n $TMUX ]; then
    fzf-tmux -p80%,80% --margin=0,0 --border "$@"
  else
    fzf --height 70% --border "$@"
  fi
}

FZF_PREFIX=${FZF_PREFIX:-"fzf-git"}

# Use @* for '--preview'
# $@ = stores all the arguments in a list of string
# $* = stores all the arguments as a single string
# $# = stores the number of arguments

function "_${FZF_PREFIX}-gf" () {
  is_in_git_repo $@ || return
  $@ ls-files |
  fzf-exec --multi --preview-window=nohidden \
    --preview "$* show HEAD:{} | bat --color=always --style=numbers,grid,header --file-name={}"
}

function "_${FZF_PREFIX}-gs" () {
  is_in_git_repo $@ || return
  $@ -c color.status=always status --short |
  fzf-exec -m --ansi --nth 2..,.. --preview-window=nohidden \
    --preview="($* diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500" |
  cut -c4- | sed 's/.* -> //'
}

function "_${FZF_PREFIX}-gb" () {
  is_in_git_repo $@ || return
  $@ branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-exec --ansi --multi --tac --preview-window nohidden,down:70% \
    --preview "$*"' log --oneline --graph --date=short --color --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) -- | head -'$LINES |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##' 
}

function "_${FZF_PREFIX}-gc" () {
  is_in_git_repo $@ || return
  $@ log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf-exec --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview-window nohidden,down:60% \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | head -1 | xargs '"$*"' show --color=always | head -'$LINES |
  grep -o "[a-f0-9]\{7,\}" | head -1
}

function "_${FZF_PREFIX}-gr" () {
  is_in_git_repo $@ || return
  $@ remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf-exec --tac \
    --preview "$*"' log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" --remotes={1} | head -200' |
  cut -d$'\t' -f1
}

# git tag
function "_${FZF_PREFIX}-gt" () {
  is_in_git_repo $@ || return
  $@ tag --sort -version:refname |
  fzf-exec --multi --preview-window nohidden,right:70% \
    --preview "$*"' show --color=always {}'
    # --preview "$*"' show --color=always {} | head -'$LINES
}

# git grep
function "_${FZF_PREFIX}-gg" () {
  if [ $1 = "git" ]; then
    is_in_git_repo $@ || return
    CMD_PREFIX="$* grep --line-number --column --color=always"
    PREVIEW_CMD="$* show HEAD:{1} | bat --color=always --style=numbers,grid,header --file-name={1} --highlight-line={2}"
  else
    # ripgrep
    CMD_PREFIX="$*"
    PREVIEW_CMD="bat --color=always --style=numbers,grid,header --highlight-line={2} -- {1}"
  fi
  INITIAL_QUERY=""
  if [ ! $INITIAL_QUERY = "" ]; then
    INITIAL_QUERY=$(print $INITIAL_QUERY | sed 's/[\\~$?*|\\[()]/\\&/g')
  fi
  sh -c "${CMD_PREFIX} '${INITIAL_QUERY}' 2>&1" |
  fzf-exec --ansi --delimiter=: --multi \
    --color hl:-1:underline,hl+:-1:underline:reverse,query:#ffffff,disabled:#f48fb1 \
    --disabled --query "$INITIAL_QUERY" \
    --bind "change:reload:sleep 0.1; $CMD_PREFIX {q} 2>&1 || true" \
    --bind "ctrl-g:unbind(change,ctrl-g)+change-prompt(fzf> )+enable-search+clear-query+rebind(ctrl-r)" \
    --bind "ctrl-r:unbind(ctrl-r)+change-prompt(regex> )+disable-search+reload($CMD_PREFIX {q} || true)+rebind(change,ctrl-g)" \
    --prompt 'regex> ' \
    --delimiter : \
    --header '╱ CTRL-R (regex mode) ╱ CTRL-G (fzf mode) ╱' \
    --preview-window 'nohidden,down,60%,border-top,+{2}+3/3,~3' \
    --preview $PREVIEW_CMD |
  cut -d':' -f1
}

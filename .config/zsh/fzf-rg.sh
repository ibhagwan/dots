#!/bin/sh

CTRL_R="\x1b[0;34m<ctrl-r>\x1b[0m"

function _fzf_rg() {
  if [ ! -z $FZF_GIT_CMD ]; then
    # git grep
    _fzf_git_check || return
    CMD_PREFIX="$FZF_GIT_CMD grep --line-number --column --color=always"
    PREVIEW_CMD="$FZF_GIT_CMD show HEAD:{1} | bat --color=always --style=numbers,grid,header --file-name={1} --highlight-line={2}"
  else
    # ripgrep
    CMD_PREFIX="rg --hidden --column --line-number --no-heading --color=always --smart-case -g '!{.git,node_modules}/*' --"
    PREVIEW_CMD="bat --color=always --style=numbers,grid,header --highlight-line={2} -- {1}"
  fi
  INITIAL_QUERY=$(cat /tmp/rg-fzf-r-$TMP_KEY 2>/dev/null)
  if [ ! $INITIAL_QUERY = "" ]; then
    INITIAL_QUERY=$(print $INITIAL_QUERY | sed 's/[\\~$?*|\\[()]/\\&/g')
  fi
  _fzf_git_fzf --ansi --multi --disabled \
    --query "$INITIAL_QUERY" \
    --bind "start:transform-header(echo ':: ${CTRL_R} to fuzzy match')+reload:[ -z {q} ] || $CMD_PREFIX {q}" \
    --bind "change:reload:sleep 0.1; $CMD_PREFIX {q} 2>&1 || true" \
    --bind 'enter:execute-silent([[ ! $FZF_PROMPT =~ regex ]] &&
    echo {q} > /tmp/rg-fzf-f-'$TMP_KEY' || echo {q} > /tmp/rg-fzf-r-'$TMP_KEY')+accept' \
    --bind 'esc:execute-silent([[ ! $FZF_PROMPT =~ regex ]] &&
    echo {q} > /tmp/rg-fzf-f-'$TMP_KEY' || echo {q} > /tmp/rg-fzf-r-'$TMP_KEY')+abort' \
    --bind 'ctrl-r:transform:[[ ! $FZF_PROMPT =~ regex ]] &&
    echo "rebind(change)+change-prompt(regex> )+disable-search+transform-header(echo \":: '${CTRL_R}' to fuzzy match\")+transform-query:echo \{q} > /tmp/rg-fzf-f-'$TMP_KEY'; cat /tmp/rg-fzf-r-'$TMP_KEY'" ||
    echo "unbind(change)+transform-prompt(echo \"\x1b[0;31m\"\{q}\"\x1b[0m > \")+enable-search+transform-header(echo \":: '${CTRL_R}' to edit regex\")+transform-query:echo \{q} > /tmp/rg-fzf-r-'$TMP_KEY'; cat /tmp/rg-fzf-f-'$TMP_KEY'"' \
    --color header:regular,hl:-1:underline,hl+:-1:underline:reverse,query:#ffffff,disabled:#f48fb1 \
    --prompt 'regex> ' \
    --delimiter : \
    --preview-window 'nohidden,down,60%,border-top,+{2}+3/3,~3' \
    --preview $PREVIEW_CMD |
  cut -d':' -f1
}

if [[ -n "${ZSH_VERSION:-}" ]]; then
    local m=""
    local k=${FZF_GIT_PREFIX:-"^f"}
    local wn="fzf-rg-${k[2]}-widget"
    eval "${wn}() { TMP_KEY=${k[2]} FZF_GIT_CMD=\"$FZF_GIT_CMD\"; local result=\$(_fzf_rg | __fzf_git_join); zle reset-prompt; LBUFFER+=\$result }"
    eval "zle -N ${wn}"
    for m in emacs vicmd viins; do
        if [ ! -z $FZF_GIT_CMD ]; then
            eval "bindkey -r '${k}g'"
            eval "bindkey -r '${k}^g'"
            eval "bindkey -M $m '${k}g' ${wn}"
            eval "bindkey -M $m '${k}^g' ${wn}"
        else
            eval "bindkey -r '$k'"
            eval "bindkey -M $m '$k' ${wn}"
        fi
    done
fi

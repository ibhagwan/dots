# default bind is ^G
FZF_GIT_BIND=${FZF_GIT_BIND:-"^G"}
FZF_GIT_CMD=${FZF_GIT_CMD:-"git"}
FZF_ZLE_PREFIX=${FZF_ZLE_PREFIX:-${FZF_PREFIX}}

join-lines() {
  local item
  while read item; do
    echo -n "${(q)item} "
  done
}

bind-git-helper() {
  local char
  for c in $@; do
    eval "${FZF_ZLE_PREFIX}-g$c-widget() { local result=\$(_${FZF_PREFIX}-g$c ${FZF_GIT_CMD} | join-lines); zle reset-prompt; LBUFFER+=\$result }"
    eval "zle -N ${FZF_ZLE_PREFIX}-g$c-widget"
    eval "bindkey '${FZF_GIT_BIND}$c' ${FZF_ZLE_PREFIX}-g$c-widget"
  done
}
bindkey -r ${FZF_GIT_BIND}
bind-git-helper f s b t r c g
unset -f bind-git-helper

# ctrl-f live grep|grep, reuses the git-grep command
fzf-rg-widget() {
  local RG_CMD="rg --hidden --column --line-number --no-heading --color=always --smart-case -g '!{.git,node_modules}/*' -- "
  local result=$(_${FZF_PREFIX}-gg ${RG_CMD} | join-lines);
  zle reset-prompt;
  LBUFFER+=$result
}
zle -N fzf-rg-widget
bindkey -r '^f'
bindkey '^f' fzf-rg-widget

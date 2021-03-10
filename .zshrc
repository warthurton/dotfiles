#-----------------------------------------------------------------------------
zstyle ':completion:*' rehash true
zstyle ':completion:*' menu select
# zmodload zsh/zprof
#-----------------------------------------------------------------------------
for s in \
  ~/.shell-common
do
  [[ -f "$s" ]] && source "$s"
done
#-----------------------------------------------------------------------------
alias -g M='| $PAGER'
(( $+commands[bat] )) && alias -g B='| bat'
bindkey -e
bindkey -m 2>/dev/null

autoload -Uz compinit && compinit
# autoload -U +X bashcompinit && bashcompinit

# if [[ -x /usr/local/bin/vault ]] ; then
#   complete -o nospace -C /usr/local/bin/vault vault
# fi
#-----------------------------------------------------------------------------
autoload -Uz zcalc
__calc() {
  zcalc -e "$*"
}
aliases[=]='noglob __calc'
#-----------------------------------------------------------------------------
if (( $+commands[direnv] )) ; then
  eval "$(direnv hook zsh)"
fi
#-----------------------------------------------------------------------------
if (( $+commands[fasd] )) ; then
  eval "$(fasd --init auto)"
fi
#-----------------------------------------------------------------------------
typeset -g -a _preferred_languages=(ruby node python)
autoload -U promptinit
promptinit
prompt chorn
#-----------------------------------------------------------------------------
for s in \
  ~/.config/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh \
  ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh \
  ~/.fzf.zsh
do
  [[ -f "$s" ]] && source "$s"
done

#-----------------------------------------------------------------------------
join-lines() {
  local item
  while read item; do
    echo -n "${(q)item} "
  done
}

bind-git-helper() {
  local c
  for c in $@; do
    eval "fzf-g$c-widget() { local result=\$(g$c | join-lines); zle && zle reset-prompt; LBUFFER+=\$result }"
    eval "zle && zle -N fzf-g$c-widget"
    eval "bindkey '^g^$c' fzf-g$c-widget"
  done
}
bind-git-helper f b t r h
unset -f bind-git-helper
#-----------------------------------------------------------------------------
typeset -g HISTFILE="$HOME/.zsh_history"
typeset -g SAVEHIST=99999999
typeset -g HISTSIZE=99999999
typeset -g WORDCHARS='*?_-.[]~&;!#$%^(){}<>'
typeset -g ZSH_AUTOSUGGEST_USE_ASYNC=1
#-----------------------------------------------------------------------------
setopt \
  always_to_end \
  auto_cd \
  auto_list \
  auto_menu \
  auto_param_slash \
  brace_ccl \
  case_glob \
  cdable_vars \
  check_jobs \
  clobber \
  combining_chars \
  complete_in_word \
  emacs \
  extended_glob \
  hash_list_all \
  interactive_comments \
  list_ambiguous \
  list_packed \
  list_types \
  long_list_jobs \
  multios \
  path_dirs \
  posix_builtins \
  prompt_subst

unsetopt \
  auto_resume \
  beep \
  bg_nice \
  complete_aliases \
  correct \
  correct_all \
  flow_control \
  hup \
  list_beep \
  mail_warning \
  menu_complete \
  notify

# History
unsetopt \
  inc_append_history

setopt \
  append_history \
  bang_hist \
  extended_history \
  hist_allow_clobber \
  hist_fcntl_lock \
  hist_find_no_dups \
  hist_ignore_space \
  hist_no_store \
  hist_reduce_blanks \
  hist_verify \
  share_history

unsetopt \
  hist_ignore_all_dups \
  inc_append_history_time
#-----------------------------------------------------------------------------
unset 'FAST_HIGHLIGHT[chroma-whatis]' 'FAST_HIGHLIGHT[chroma-man]' 'FAST_HIGHLIGHT[chroma-make]'
#-----------------------------------------------------------------------------
_preserve_my_history() {
  [[ -d "$HOME/.git-prv-dotfiles" ]] || return
  git --git-dir="$HOME/.git-prv-dotfiles" --work-tree="$HOME" commit --no-gpg-sign -am "$(date)" >&/dev/null &!
}

typeset -g PERIOD=600
autoload -Uz add-zsh-hook
add-zsh-hook periodic _preserve_my_history
#-----------------------------------------------------------------------------
# vim: set syntax=zsh ft=zsh sw=2 ts=2 expandtab:


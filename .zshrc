#-----------------------------------------------------------------------------
zstyle ':completion:*' rehash true
zstyle ':completion:*' menu select
#-----------------------------------------------------------------------------
for s in \
  ~/.shell-common
do
  [[ -f "$s" ]] && source "$s"
done
#-----------------------------------------------------------------------------
typeset -g -a _preferred_languages=(ruby rust)

alias -g M='| $PAGER'
(( $+commands[bat] )) && alias -g B='| bat'
bindkey -e
bindkey -m 2>/dev/null

autoload -Uz compinit && compinit -D
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
typeset -g HISTFILE="$HOME/.zsh_history"
typeset -g SAVEHIST=99999999
typeset -g HISTSIZE=99999999
typeset -g WORDCHARS='*?_-.[]~&;!#$%^(){}<>'
# typeset -g PROMPT='%f%b%k%u%s%n@%m %~ %(!.#.$)%f%b%k%u%s '
# typeset -g RPROMPT=''
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
  inc_append_history \
  inc_append_history_time
#-----------------------------------------------------------------------------
unset 'FAST_HIGHLIGHT[chroma-whatis]' 'FAST_HIGHLIGHT[chroma-man]'
#-----------------------------------------------------------------------------
# vim: set syntax=zsh ft=zsh sw=2 ts=2 expandtab:

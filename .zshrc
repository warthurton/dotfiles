#-----------------------------------------------------------------------------
for s in \
    ~/.shell-common \
    ~/.zsh-git \
    ~/.config/zsh/zsh-async/async.zsh
do
  if [[ -f "$s" ]] ; then
    source "$s"
  else
    echo "ERROR: $s is an expected dependency"
  fi
done
#-----------------------------------------------------------------------------
for s in \
    ~/.fzf.zsh \
    ~/.config/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh \
    ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh \
    ~/.config/zsh/forgit/forgit.plugin.zsh
do
  [[ -f "$s" ]] && source "$s"
done

#-----------------------------------------------------------------------------
fpath=(/usr/local/share/zsh-completions $fpath)
#-----------------------------------------------------------------------------
PROMPT='$(dump_prompt)'
RPROMPT=''

alias -g M='| $PAGER'
bindkey -e
bindkey -m 2>/dev/null

autoload -Uz add-zsh-hook compinit colors zcalc

compinit -C
colors
#-----------------------------------------------------------------------------
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
typeset -g -a _preferred_languages=(ruby node python rust)
typeset -g -A _preferred_language_commands=(ruby ruby node node python python rust rustc)
typeset -g -A _prompt
typeset -g -a _prompt_procs
#-----------------------------------------------------------------------------
_nonprintable_begin() {
  print -n '\001'
}
#-----------------------------------------------------------------------------
_nonprintable_end() {
  print -n '\002'
}
#-----------------------------------------------------------------------------
_language_version() {
  local language="$1"
  local cmd="${_preferred_language_commands[$language]}"

  if ! (( $+commands[$cmd] )) ; then
    echo "none"
    return
  fi

  case "$language" in
    ruby)
      "$cmd" --version | awk '{print $2}'
      ;;
    node)
      "$cmd" --version | sed -e 's/^v//'
      ;;
    python*)
      "$cmd" --version |& awk '{print $2}'
      ;;
    elixir)
      "$cmd" --version |& grep '^Elixir' | awk '{print $2}'
      ;;
    rust)
      "$cmd" --version |& awk '{print $2}'
      ;;
  esac
}
#-----------------------------------------------------------------------------
_prompt_reset() {
  print -n "%f%b%k%u%s"
}
#-----------------------------------------------------------------------------
_prompt_time() {
  print -n "%F{8}%D{%H:%M:%S}"
}
#-----------------------------------------------------------------------------
_prompt_user() {
  if am_i_someone_else ; then
    print -n "%F{9}_%n_"
  fi
}
#-----------------------------------------------------------------------------
_prompt_host() {
  if [[ -n $SSH_TTY ]] ; then
    print -n "%F{15}@%F{14}%m"
  fi
}
#-----------------------------------------------------------------------------
_prompt_path() {
  print -n "%F{7}%~"
}
#-----------------------------------------------------------------------------
_prompt_languages() {
  local -a _langs
  for language in ${_preferred_languages[@]} ; do
    _langs+=("%F{6}${language}-$(_language_version $language)")
  done

  print -n "${_langs[@]}"
}
#-----------------------------------------------------------------------------
_prompt_gitrepo() {
  (( $+commands[git] )) || return
  _prompt_update_git
  local _git_prompt="$(build_git_status)"

  if [[ -n "${_git_prompt}" ]] ; then
    print -n "%f${_git_prompt}"
  fi
}
#-----------------------------------------------------------------------------
_prompt_gitconfigs() {
  (( $+commands[git] )) || return
  # [[ "$PWD" == "$HOME" ]] || return

  if typeset -f pubgit >&/dev/null ; then
    _prompt_update_git pubgit .git-pub-dotfiles
    print -n "%F{8}PUB:%f$(build_git_status pubgit)"
  fi

  if typeset -f prvgit >&/dev/null ; then
    _prompt_update_git prvgit .git-prv-dotfiles
    print -n ' '
    print -n "%F{8}PRV:%f$(build_git_status prvgit)"
  fi
}
#-----------------------------------------------------------------------------
_update_fast_left_prompt_parts() {
  _prompt=()
  _prompt[time]="$(_prompt_time)"
  _prompt[user]="$(_prompt_user)"
  _prompt[host]="$(_prompt_host)"
  _prompt[path]="$(_prompt_path)"
}
#-----------------------------------------------------------------------------
dump_prompt() {
  local -a _line1=()
  local -a _line2=()

  for piece in languages gitrepo gitconfigs ; do
    [[ -n "${_prompt[$piece]}" ]] && _line1+=("${_prompt[$piece]}")
  done

  for piece in time user host path ; do
    [[ -n "${_prompt[$piece]}" ]] && _line2+=("${_prompt[$piece]}")
  done

  _prompt_reset
  (( ${#_line1[@]} > 0 )) && print "${_line1[@]}"

  print -n "${_line2[@]}"
  print -n ' %(?.%F{7}.%F{15})%? %(!.#.$)'
  _prompt_reset
  print -n ' '
}
#-----------------------------------------------------------------------------
_async_prompt_languages() {
  cd -q "$1"
  echo "_prompt[languages]=\"$(_prompt_languages)\""
}
#-----------------------------------------------------------------------------
_async_prompt_gitrepo() {
  cd -q "$1"
  echo "_prompt[gitrepo]=\"$(_prompt_gitrepo)\""
}
#-----------------------------------------------------------------------------
_async_prompt_gitconfigs() {
  cd -q "$1"
  echo "_prompt[gitconfigs]=\"$(_prompt_gitconfigs)\""
}

#-----------------------------------------------------------------------------
_async_prompt_callback() {
  [[ -n "$3" ]] && eval "$3" && zle && zle reset-prompt >&/dev/null
}
#-----------------------------------------------------------------------------
prompt_precmd() {
  _update_fast_left_prompt_parts
  async_job 'prompt_worker' _async_prompt_languages "$PWD"
  async_job 'prompt_worker' _async_prompt_gitrepo "$PWD"
  async_job 'prompt_worker' _async_prompt_gitconfigs "$PWD"
}
#-----------------------------------------------------------------------------
typeset -f async_init >&/dev/null || return
async_init

async_start_worker 'prompt_worker' -n
async_register_callback 'prompt_worker' _async_prompt_callback

add-zsh-hook precmd prompt_precmd
#-----------------------------------------------------------------------------
# vim: set syntax=zsh ft=zsh sw=2 ts=2 expandtab:

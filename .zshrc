#-----------------------------------------------------------------------------
# ~/.config/zsh/zsh-async/async.zsh \
for s in  ~/.shell-common \
          ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh \
          ~/.config/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh \
          ~/.fzf.zsh \
          ~/.zsh-git
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

autoload -Uz compinit colors
compinit -C
colors

#-----------------------------------------------------------------------------
typeset -g -a _preferred_languages=(ruby node python rust)
typeset -g -A _prompt
typeset -g -a _prompt_procs
#-----------------------------------------------------------------------------
_hey_readline_i_am_not_part_of_your_linelength() {
  print -Pn "\e]0;\a"
}
#-----------------------------------------------------------------------------
_language_version() {
  local language="$1"

  if ! (( $+commands[$language] )) ; then
    echo "none"
    return
  fi

  case "$language" in
    ruby)
      ruby --version | awk '{print $2}'
      ;;
    node)
      node --version | sed -e 's/^v//'
      ;;
    python*)
      "$language" --version |& awk '{print $2}'
      ;;
    elixir)
      "$language" --version |& grep '^Elixir' | awk '{print $2}'
      ;;
    *)
      "$language" --version
      ;;
  esac
}
#-----------------------------------------------------------------------------
_prompt_reset() {
  print -Pn "%f%b%k%u%s"
}
#-----------------------------------------------------------------------------
_prompt_time() {
  print -Pn "%F{8}%D{%H:%M:%S}"
}
#-----------------------------------------------------------------------------
_prompt_user() {
  if am_i_someone_else ; then
    print -Pn "%F{9}_%n_"
  fi
}
#-----------------------------------------------------------------------------
_prompt_host() {
  if [[ -n $SSH_TTY ]] ; then
    print -Pn "%F{15}@%F{14}%m"
  fi
}
#-----------------------------------------------------------------------------
_prompt_path() {
  print -Pn "%F{7}%~"
}
#-----------------------------------------------------------------------------
_prompt_languages() {
  local -a _langs
  for language in ${_preferred_languages[@]} ; do
    _langs+=("%F{6}${language}-$(_language_version $language)")
  done

  print -Pn "${_langs[@]}"
}
#-----------------------------------------------------------------------------
_prompt_gitrepo() {
  (( $+commands[git] )) || return
  _prompt_update_git
  local _git_prompt="$(build_git_status)"

  if [[ -n "${_git_prompt}" ]] ; then
    print -Pn "%f${_git_prompt}"
  fi
}
#-----------------------------------------------------------------------------
_prompt_gitconfigs() {
  (( $+commands[git] )) || return
  # [[ "$PWD" == "$HOME" ]] || return

  if typeset -f pubgit >&/dev/null ; then
    _prompt_update_git pubgit .git-pub-dotfiles
    print -Pn "%F{8}PUB:%f$(build_git_status pubgit)"
  fi

  if typeset -f prvgit >&/dev/null ; then
    _prompt_update_git prvgit .git-prv-dotfiles
    print -Pn " "
    print -Pn "%F{8}PRV:%f$(build_git_status prvgit)"
  fi
}
#-----------------------------------------------------------------------------
_update_fast_left_prompt_parts() {
  _prompt=()
  _prompt[reset]="$(_prompt_reset)"
  _prompt[time]="$(_prompt_time)"
  _prompt[user]="$(_prompt_user)"
  _prompt[host]="$(_prompt_host)"
  _prompt[path]="$(_prompt_path)"
  _prompt[reset]="$(_prompt_reset)"
}
#-----------------------------------------------------------------------------
dump_prompt() {
  declare -p _prompt > ~/zsh.debug
  local -a _line1=()
  local -a _line2=()

  for piece in languages gitconfigs ; do
    [[ -n "${_prompt[$piece]}" ]] && _line1+=("${_prompt[$piece]}")
  done

  for piece in time user host path gitrepo ; do
    [[ -n "${_prompt[$piece]}" ]] && _line2+=("${_prompt[$piece]}")
  done

  echo -n "${_prompt[reset]}"
  (( ${#_line1[@]} > 0 )) && echo "${_line1[@]}"


  echo -n "${_line2[@]}"
  echo -n ' %(?.%F{7}.%F{15})%? %(!.#.$)%f%b%k%u%s '

  _hey_readline_i_am_not_part_of_your_linelength
}
#-----------------------------------------------------------------------------
_async_prompt_languages() {
  echo "_prompt[languages]=\"$(_prompt_languages)\""
}
#-----------------------------------------------------------------------------
_async_prompt_gitrepo() {
  echo "_prompt[gitrepo]=\"$(_prompt_gitrepo)\""
}
#-----------------------------------------------------------------------------
_async_prompt_gitconfigs() {
  echo "_prompt[gitconfigs]=\"$(_prompt_gitconfigs)\""
}
#-----------------------------------------------------------------------------
precmd() {
  _update_fast_left_prompt_parts

  if [[ "${#_prompt_procs[@]}" -gt 0 ]] ; then
    for pid in "${_prompt_procs[@]}" ; do
      kill -0 "$pid" >&/dev/null && kill -s HUP "$pid" >&/dev/null
    done
    _prompt_procs=()
  fi

  typeset -g _prompt_file_left="$HOME/.zsh_prompt_left_${$}_${RANDOM}"

  () {
    cat "$1" >> "$_prompt_file_left"
    kill -s USR1 $$
  } =(_async_prompt_languages) &!
  _prompt_procs+=($!)

  () {
    cat "$1" >> "$_prompt_file_left"
    kill -s USR1 $$
  } =(_async_prompt_gitrepo) &!
  _prompt_procs+=($!)

  () {
    cat "$1" >> "$_prompt_file_left"
    kill -s USR1 $$
  } =(_async_prompt_gitconfigs) &!
  _prompt_procs+=($!)
}

#-----------------------------------------------------------------------------
TRAPUSR1() {
  eval "$(<$_prompt_file_left)" && zle && zle reset-prompt >&/dev/null
}
#-----------------------------------------------------------------------------
TRAPWINCH() {
  zle && zle reset-prompt >&/dev/null
}
#-----------------------------------------------------------------------------
PERIOD=10
periodic() {
  find "$HOME" -type f -maxdepth 1 -mtime +10s -name '.zsh_prompt_*' -delete
}
#-----------------------------------------------------------------------------
if (( $+commands[direnv] )) ; then
  eval "$(direnv hook zsh)"
fi
#-----------------------------------------------------------------------------
if (( $+commands[fasd] )) ; then
  eval "$(fasd --init auto)"
fi
#-----------------------------------------------------------------------------
# vim: set syntax=zsh ft=zsh sw=2 ts=2 expandtab:

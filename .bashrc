#!/usr/bin/env bash
# --------------------------------------------------------------------------
export HISTCONTROL=ignoreboth
export HISTFILE="$HOME/.bash_history"
export HISTFILESIZE=10000000
export INPUTRC="$HOME/.bash_inputrc"
# export PS1='\t \u@\h \w \$ '

set -o emacs -o monitor -o notify
shopt -qs checkwinsize cmdhist expand_aliases histappend hostcomplete interactive_comments nocaseglob nocasematch no_empty_cmd_completion progcomp promptvars sourcepath
shopt -qu mailwarn

if [[ "$BASH_VERSINFO" -gt "3" ]] ; then
  shopt -qs autocd checkjobs
fi

# --------------------------------------------------------------------------
[[ -s "$HOME/.shell-env" ]] && source "$HOME/.shell-env"
[[ -s "$HOME/.shell-path" ]] && source "$HOME/.shell-path"
[[ -z "$PS1" ]] && return

for s in "$HOME/.shell-common" "$HOME/.fzf.bash" ; do
  [[ -s "$s" ]] && source "$s"
done
# --------------------------------------------------------------------------
_completion_loader() {
  local _command="$1"
  local _completion
  local _completion_script
  for _completion_dir in /etc/bash_completion.d /usr/local/etc/bash_completion.d ; do
    _completion="${_completion_dir}/${_command}"

    for _completion_script in "${_completion}" "${_completion}.sh" ; do
      if [[ -s "${_completion_script}" ]] ; then
        source "${_completion_script}" >/dev/null 2>&1 && return 124
      fi
    done
  done
}

complete -D -F _completion_loader -o bashdefault -o default
# --------------------------------------------------------------------------
pw() { p | "$PAGER" ; }

if ! command -v __git_ps1 >/dev/null 2>/dev/null ; then
  [[ -s "$HOME/bin/git-prompt.sh" ]] && source "$HOME/bin/git-prompt.sh"
fi

# Colors---------------------------------------------------------------------
_ps1_time_color() { echo -n ''; }
_ps1_id_color() { echo -n ''; }
_ps1_id() { echo -n ''; }
_ps1_ruby() { echo -n ''; }
_ps1_git_color() { echo -n ''; }
_ps1_git() { echo -n ''; }

ps1_update() {
  export PS1='\[$__reset\]\[$(_ps1_time_color)\]\t\[$__reset\] \[$(_ps1_id_color)\]$(_ps1_id)\[$__reset\]@\[$(_ps1_time_color)\]\h\[$__reset\]$(_ps1_ruby)\[$(_ps1_git_color)\]$(_ps1_git)\[$__reset\] \w \$ '
}
export PROMPT_COMMAND="ps1_update"

[[ -z $TERM || $TERM = "dumb" ]] && return

__reset=$(tput sgr0)

color() {
  tput setaf "$1"
  return 0
}
# Prompt---------------------------------------------------------------------
_ps1_time_color() {
  if [[ $? -eq 0 ]] ; then
    color 4
  else
    color 1
  fi
  return 0
}
_ps1_id_color() {
  if [[ $UID -eq 0 ]] ; then
    color 9
  else
    color 7
  fi
  return 0
}
_ps1_id() {
  if [[ $EUID -eq 0 ]] ; then
    echo -n "__ROOT__"
  else
    echo -n "$USER"
  fi
  return 0
}
if command -v ruby >/dev/null 2>/dev/null ; then
  _ps1_ruby() {
    _RUBY_VERSION=$(ruby --version)
    _RUBY=${_RUBY_VERSION/ruby /ruby-}
    printf "%s" " ${_RUBY/ */}"
    return 0
  }
fi
if command -v git >/dev/null 2>/dev/null ; then
  _ps1_git_color() {
    declare __LOCAL_GIT_STATUS
    __LOCAL_GIT_STATUS="$(git status -unormal 2>&1)"
    export __LOCAL_GIT_STATUS
    if ! [[ "$__LOCAL_GIT_STATUS" =~ Not\ a\ git\ repo ]]; then
      if [[ "$__LOCAL_GIT_STATUS" =~ nothing\ to\ commit ]]; then
        color 10
      elif [[ "$__LOCAL_GIT_STATUS" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
        color 11
      else
        color 9
      fi
    fi
    return 0
  }
  _ps1_git() {
    if [[ "$__LOCAL_GIT_STATUS" =~ On\ branch\ ([^[:space:]]+) ]]; then
      branch=${BASH_REMATCH[1]}
      test "$branch" != master || branch=' '
    else
      branch="($(git describe --all --contains --abbrev=4 HEAD 2> /dev/null || echo HEAD))"
    fi
    printf "%s" "$(__git_ps1)"
    return 0
  }
fi

# vim: set syntax=sh ft=sh sw=2 ts=2 expandtab:

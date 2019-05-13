# --------------------------------------------------------------------------
export HISTFILE="$HOME/.bash_history"
export HISTCONTROL=ignorespace
export HISTFILESIZE=999999999
export INPUTRC="$HOME/.bash_inputrc"

set -o emacs -o monitor -o notify
shopt -qs checkwinsize cmdhist expand_aliases histappend hostcomplete histverify interactive_comments nocaseglob nocasematch no_empty_cmd_completion progcomp promptvars sourcepath
shopt -qu mailwarn

if [[ "${BASH_VERSINFO[0]}" -gt "3" ]] ; then
  shopt -qs autocd checkjobs
fi

# --------------------------------------------------------------------------
for s in "$HOME/.shell-path" "$HOME/.shell-env" "$HOME/.shell-common" ; do
  [[ -s "$s" ]] && source "$s"
done
# --------------------------------------------------------------------------
if command -v direnv >/dev/null 2>/dev/null ; then
  eval "$(direnv hook bash)"
fi
# --------------------------------------------------------------------------
[[ -z "$PS1" ]] && return
# --------------------------------------------------------------------------
for s in "$HOME/.fzf.bash"  "${HOME}/.iterm2_shell_integration.bash" ; do
  [[ -s "$s" ]] && source "$s"
done
# --------------------------------------------------------------------------
export PS1='\t \u@\h \w \$ '
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

if [[ "${BASH_VERSINFO[0]}" -gt 3 ]] ; then
  complete -D -F _completion_loader -o bashdefault -o default
fi
# --------------------------------------------------------------------------
pw() { p | "$PAGER" ; }

if ! command -v __git_ps1 >/dev/null 2>/dev/null ; then
  [[ -s "$HOME/bin/git-prompt.sh" ]] && source "$HOME/bin/git-prompt.sh"
fi

# Colors---------------------------------------------------------------------
[[ -z $TERM || $TERM = "dumb" || $TERM = "tty" ]] && return
command -v tput >&/dev/null || return
# Colors---------------------------------------------------------------------
_ps1_time_color() { echo -n ''; }
_ps1_id_color() { echo -n ''; }
_ps1_id() { echo -n ''; }
_ps1_git_color() { echo -n ''; }
_ps1_git() { echo -n ''; }

ps1_update() {
  export PS1='\[$__reset\]\[$(_ps1_time_color)\]\t\[$__reset\] \[$(_ps1_id_color)\]$(_ps1_id)\[$__reset\]@\[$(_ps1_time_color)\]\h\[$__reset\]\[$(_ps1_git_color)\]$(_ps1_git)\[$__reset\] \w \$ '
}
export PROMPT_COMMAND="ps1_update"
# export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"   # mem/file sync
# if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hh -- \C-j"'; fi

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
  if command -v am_i_someone_else >&/dev/null && am_i_someone_else; then
    echo -n "__${USER}__"
  else
    echo -n "$USER"
  fi
  return 0
}
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
#--------------------------------------------------------------------------
# vim: set syntax=sh ft=sh sw=2 ts=2 expandtab:

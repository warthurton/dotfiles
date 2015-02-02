# --------------------------------------------------------------------------
set -o emacs -o monitor -o notify
shopt -qs autocd checkwinsize cmdhist expand_aliases histappend hostcomplete interactive_comments nocaseglob nocasematch no_empty_cmd_completion progcomp promptvars sourcepath checkjobs
shopt -qu mailwarn

export HISTCONTROL=ignoreboth
export HISTFILE="$HOME/.bash_history"
export HISTFILESIZE=10000000
export INPUTRC="$HOME/.bash_inputrc"
export PS1='\t \u@\h \w \$ '

unset __messy_path
unset __cleaned_path
unset __path_check
declare -A __path_check

__messy_path+=(/Applications/VMware\ Fusion.app/Contents/Library /Applications/Postgres.app/Contents/Versions/9.4}/bin /{usr,opt}/{local,X11}/{bin,sbin} $HOME/bin)
__messy_path+=($(IFS=:; echo $PATH))
__messy_path+=(/{usr,opt}/{bin,sbin} /{bin,sbin})

for p in "${__messy_path[@]}" ; do
  [[ -d "$p" && -z "${__path_check[$p]}" ]] || continue
  __path_check[$p]=1
  __cleaned_path+=($p)
done

export PATH=$(IFS=:; echo "${__cleaned_path[*]}")

# --------------------------------------------------------------------------
[[ -s "$HOME/.shell-env" ]] && source "$HOME/.shell-env"
[ -z "$PS1" ] && return
[[ -s "$HOME/.shell-common" ]] && source "$HOME/.shell-common"
# --------------------------------------------------------------------------

lm() { ls -lF $2 | $PAGER; }
pw() { p | $PAGER; }

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
  tput setaf $1
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
    echo -n $USER
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
    export __LOCAL_GIT_STATUS="`git status -unormal 2>&1`"
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
      branch="(`git describe --all --contains --abbrev=4 HEAD 2> /dev/null || echo HEAD`)"
    fi
    printf "$(__git_ps1)"
    return 0
  }
fi


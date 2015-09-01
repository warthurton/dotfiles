# --------------------------------------------------------------------------
alias -g M='|& $PAGER'
bindkey -e
bindkey -m 2>/dev/null
# --------------------------------------------------------------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

for s in  ~/.shell-common \
          ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
          ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh \
          ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
do
  [[ -f "$s" ]] && source "$s"
done
# --------------------------------------------------------------------------
zstyle ':completion::complete:*' use-cache on
compinit
bashcompinit
# --------------------------------------------------------------------------
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr ' %F{10}\U03B4%f'
zstyle ':vcs_info:*' unstagedstr ' %F{11}\U03B4%f'

__vcs_info_git_format='%c%u %b %F{8}%8.8i%f %m'

zstyle ':vcs_info:git*' formats "${__vcs_info_git_format}"
zstyle ':vcs_info:git*' actionformats " %F{15}%a%f ${__vcs_info_git_format}"
zstyle ':vcs_info:git*+set-message:*' hooks git-status

function +vi-git-status() {
  git rev-parse --is-inside-work-tree >& /dev/null || return

  local branch
  branch="${hook_com[branch]}"

  local -i seconds_since_last_commit
  local -i unstaged_changes
  local -i untracked_files

  local -i _weeks_since=0
  local -i _days_since=0
  local -i _hours_since=0
  local -i _minutes_since=0
  local _since

  seconds_since_last_commit=$(( $EPOCHSECONDS - $(git log --pretty=format:'%at' -1) ))

  if (( seconds_since_last_commit > 60 )) ; then
    (( _seconds = seconds_since_last_commit ))

    (( _weeks_since = _seconds / (60 * 60 * 24 * 7) ))
    (( _seconds = _seconds - ( _weeks_since * 60 * 60 * 24 * 7) ))

    (( _days_since = _seconds / (60 * 60 * 24) ))
    (( _seconds = _seconds - ( _days_since * 60 * 60 * 24 ) ))

    (( _hours_since = _seconds / (60 * 60) ))
    (( _seconds = _seconds - ( _hours_since * 60 * 60 ) ))

    (( _minutes_since = _seconds / 60 ))
    (( _seconds = _seconds - ( _minutes_since * 60 ) ))

    if (( _weeks_since > 0 )) ; then
      _since="${_since}${_weeks_since}w"
    fi
    if (( _weeks_since > 0 || _days_since > 0 )) ; then
      _since="${_since}${_days_since}d"
    fi
    if (( _weeks_since > 0 || days_since > 0 || _hours_since > 0 )) ; then
      _since="${_since}${_hours_since}h"
    fi
    if (( _weeks_since > 0 || _days_since > 0 || _hours_since > 0 || _minutes_since > 0 )) ; then
      _since="${_since}${_minutes_since}m"
    fi
  fi

  unstaged_changes=$( git status --porcelain | grep -c '^ M' )
  untracked_files=$( git status --porcelain | grep -c '^??' )

  if (( unstaged_changes > 0 && seconds_since_last_commit > (60 * 60 * 2) )) ; then
    hook_com[branch]="%F{9}${branch}%f"
    hook_com[unstaged]+=" %F{9}${_since}%f"
  elif (( unstaged_changes > 0 && seconds_since_last_commit > (60 * 60) )) ; then
    hook_com[branch]="%F{3}${branch}%f"
    hook_com[unstaged]+=" %F{3}${_since}%f"
  else
    hook_com[branch]="%F{2}${branch}%f"
  fi

  if (( untracked_files > 0 )) ; then
    hook_com[unstaged]+=' %F{13}?%f'
  fi

  local remote=${$(git rev-parse --verify ${branch}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

  if [[ -n ${remote} ]] ; then
    local -i ahead
    local -i behind
    local -a gitstatus

    [[ ${remote#*/} != ${branch} ]] && gitstatus+=(${remote})

    ahead=$(git rev-list ${branch}@{upstream}..HEAD 2>/dev/null | wc -l)
    (( ahead )) && gitstatus+=( "%F{2}+${ahead}%f" )

    behind=$(git rev-list HEAD..${branch}@{upstream} 2>/dev/null | wc -l)
    (( behind )) && gitstatus+=( "%F{5}-${behind}%f" )

    (( ${#gitstatus} > 0 )) && hook_com[branch]+=" %F{8}[%f${(j: :)gitstatus}%F{8}]%f"
  fi

  local -i stashes
  if [[ -s ${hook_com[base]}/.git/refs/stash ]] ; then
    stashes=$(git stash list 2>/dev/null | wc -l)
    hook_com[misc]+="%F{7}(${stashes} stashed)%f"
  fi
}

#-----------------------------------------------------------------------------
_ruby_version() {
  local raw

  if (( $+commands[ruby] )) ; then
    raw=$(ruby --version)
    export RUBY_VERSION="${${raw/ruby /ruby-}/ *}"

    echo -n "${_RUBY/ */}"
  fi
}

_darwin_unlocked() {
  export DARWIN_UNLOCKED=""

  if [[ "${OSTYPE:0:6}" = "darwin" && $USER != "root" && $(defaults read com.apple.screensaver askForPassword) != "1" ]] ; then
    export DARWIN_UNLOCKED="UNLOCKED"
  fi
}

precmd() {
  _darwin_unlocked
  vcs_info
  _ruby_version
  print -Pn "\e]0;\a"
}

build_multi_prompt() {
  # [[ -z $TMUX ]] || return

  # security
  [[ -n $DARWIN_UNLOCKED ]] && echo -n "%F{11}${DARWIN_UNLOCKED} "

  # ruby
  [[ -n $RUBY_VERSION ]] && echo -n "%F{1}${RUBY_VERSION}"

  echo -n "%f${vcs_info_msg_0_%% }"

  echo -n ' %F{7}%~\n'

  # Time
  echo -n '%F{8}%D{%H:%M:%S} '

  # user
  case $USER in
    chorn)
      echo -n '%F{4}%n'
      ;;
    root)
      echo -n '%F{9}__ROOT__'
      ;;
    *)
      echo -n '%F{11}%n'
      ;;
  esac

  # host
  case $HOST in
    Shodan*)
      echo -n "%F{15}@%F{4}%m"
      ;;
    *)
      echo -n "%F{15}@%F{14}%m"
      ;;
  esac

  # path
  echo -n ' %(?.%F{7}.%F{15})%? %(!.#.$) '
}

build_lprompt() {

  # user
  case $USER in
    chorn)
      echo -n "%F{4}%n"
      ;;
    root)
      echo -n "%F{9}__ROOT__"
      ;;
    *)
      echo -n "%F{11}%n"
      ;;
  esac

  # host
  case $HOST in
    Shodan*)
      echo -n "%F{15}@%F{4}%m"
      ;;
    *)
      echo -n "%F{15}@%F{14}%m"
      ;;
  esac

  # ruby
  [[ -n $RUBY_VERSION ]] && echo -n " %F{1}${RUBY_VERSION}"

  echo -n "%f${vcs_info_msg_0_%% }"

  # path
  echo -n ' %F{7}%~ %(?.%F{7}.%F{15})%? %(!.#.$) '
}

# export PROMPT="%f%b%k%u%s\$(build_lprompt)%f%b%k%u%s"
export PROMPT="%f%b%k%u%s\$(build_multi_prompt)%f%b%k%u%s"
unset RPROMPT

# --------------------------------------------------------------------------
# vim: set syntax=sh ft=zsh sw=2 ts=2 expandtab:


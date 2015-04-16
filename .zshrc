# --------------------------------------------------------------------------
alias -g M='|& $PAGER'

# --------------------------------------------------------------------------
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

__vcs_info_git_format='%c%u %b %F{8}%6.6i%f %m'

zstyle ':vcs_info:git*' formats "${__vcs_info_git_format}"
zstyle ':vcs_info:git*' actionformats " %F{15}%a%f ${__vcs_info_git_format}"
zstyle ':vcs_info:git*+set-message:*' hooks git-status

function +vi-git-status() {
  git rev-parse --is-inside-work-tree >& /dev/null || return

  local branch
  branch="${hook_com[branch]}"

  local -i minutes_since_last_commit
  local -i unstaged_changes
  local -i untracked_files

  minutes_since_last_commit=$(( ($EPOCHSECONDS - $(git log --pretty=format:'%at' -1)) / 60 ))
  unstaged_changes=$( git status --porcelain | grep -c '^ M' )
  untracked_files=$( git status --porcelain | grep -c '^??' )

  if (( unstaged_changes > 0 && minutes_since_last_commit > 90 )) ; then
    hook_com[branch]="%F{9}${branch}%f"
    hook_com[unstaged]+=" %F{9}${minutes_since_last_commit}m%f"
  elif (( unstaged_changes > 0 && minutes_since_last_commit > 30 )) ; then
    hook_com[branch]="%F{3}${branch}%f"
    hook_com[unstaged]+=" %F{3}${minutes_since_last_commit}m%f"
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
    hook_com[misc]+=" %F{7}(${stashes} stashed)%f"
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

precmd() {
  vcs_info
  _ruby_version
  print -Pn "\e]0;\a"
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

build_rprompt() {
  [[ -z $TMUX ]] || return

  # security
  if [[ "${OSTYPE:0:6}" = "darwin" && $USER != "root" ]] ; then
    if [[ $(defaults read com.apple.screensaver askForPassword) != "1" ]] ; then
      echo -n ' %F{11}UNLOCKED'
    fi
  fi

  # Time
  echo -n ' %F{8}%D{%H:%M:%S}'
}

export PROMPT="%f%b%k%u%s\$(build_lprompt)%f%b%k%u%s"
export RPROMPT="%f%b%k%u%s\$(build_rprompt)%f%b%k%u%s"

# --------------------------------------------------------------------------
# vim: ft=zsh sw=2 ts=2 et

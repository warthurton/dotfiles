#-----------------------------------------------------------------------------
for s in  ~/.shell-common \
          ~/.ghq/github.com/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh \
          ~/.ghq/github.com/zsh-users/zsh-history-substring-search/zsh-history-substring-search.zsh \
          ~/.ghq/github.com/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
          ~/.fzf.zsh
do
  [[ -f "$s" ]] && source "$s"
done
#-----------------------------------------------------------------------------
fpath=($HOME/.ghq/github.com/zsh-users/zsh-completions/src "$HOME/.config/zsh/site-functions" $fpath)
typeset -gU fpath path
#-----------------------------------------------------------------------------
# export PROMPT="%f%b%k%u%s%n@%m %~ %(!.#.$)%f%b%k%u%s "
export PROMPT="\$(build_left_prompt)"
export RPROMPT=""

alias -g M='|& $PAGER'
bindkey -e
bindkey -m 2>/dev/null

autoload -Uz compinit colors add-zsh-hook
compinit -C
colors
#-----------------------------------------------------------------------------
if (( $+commands[git] )) ; then
  typeset -g -A __git_theme=(
    prefix "("
    suffix ")"
    separator "|"
    branch "%{$fg_bold[magenta]%}"
    clean "%{$fg_bold[green]%}%{✔%G%}"
    changed "%{$fg[blue]%}%{✚%G%}"
    staged "%{$fg[red]%}%{●%G%}"
    conflicts "%{$fg[red]%}%{✖%G%}"
    oid "%{$fg[gray]%}"
    ahead "%{↑%G%}"
    behind "%{↓%G%}"
    untracked "%{…%G%}"
    show_changed_count 1
    show_staged_count 1
    show_conflict_count 1
    show_ahead_count 1
    show_behind_count 1
    show_untracked_count 0
  )
  #----------
  __git_theme[branch]="%{$reset_color%}${__git_theme[branch]}"
  __git_theme[clean]="%{$reset_color%}${__git_theme[clean]}"
  __git_theme[changed]="%{$reset_color%}${__git_theme[changed]}"
  __git_theme[staged]="%{$reset_color%}${__git_theme[staged]}"
  __git_theme[conflicts]="%{$reset_color%}${__git_theme[conflicts]}"
  __git_theme[ahead]="%{$reset_color%}${__git_theme[ahead]}"
  __git_theme[behind]="%{$reset_color%}${__git_theme[behind]}"
  __git_theme[untracked]="%{$reset_color%}${__git_theme[untracked]}"
  __git_theme[oid]="%{$reset_color%}${__git_theme[oid]}"

  typeset -g -A __language_versions
  typeset -g -A __local_language_versions
  typeset -g -A __git_status
  #----------
  add-zsh-hook chpwd _zsh_git_prompt__chpwd_hook
  add-zsh-hook preexec _zsh_git_prompt__preexec_hook
  add-zsh-hook precmd _zsh_git_prompt__precmd_hook
  #----------
  function _zsh_git_prompt__preexec_hook() {
    unset __EXECUTED_GIT_COMMAND
    [[ "$2" =~ ^(git|hub|gh|stg) ]] && typeset -g __EXECUTED_GIT_COMMAND=1
  }
  #----------
  function _zsh_git_prompt__precmd_hook() {
    [[ -n "$__EXECUTED_GIT_COMMAND" ]] && _zsh_git_prompt__update_vars "${1:=git}"
  }
  #----------
  function _zsh_git_prompt__chpwd_hook() {
    _zsh_git_prompt__update_vars "${1:=git}"
  }
  #----------
  function _zsh_git_prompt__update_vars() {
    local _git_command="${1:=git}"

    typeset -A g=(staged 0 conflicts 0 changed 0 untracked 0 ignored 0 no_repository 0 clean 0)

    while read -rA _status ; do
      case "${_status[1]}" in
        fatal*)
          g[no_repository]=1
          ;;
        \#)
          case "${_status[2]}" in
            branch.oid)
              g[oid]="${_status[3]:0:8}"
              ;;
            branch.head)
              g[branch]="${_status[3]}"
              ;;
            branch.upstream)
              g[upstream]="${_status[3]}"
              ;;
            branch.ab)
              g[ahead]=$((${_status[3]}))
              g[behind]=$((${_status[4]}))
              ;;
          esac
          ;;
        \?)
          (( g[untracked]++ ))
          ;;
        \!)
          (( g[ignored]++ ))
          ;;
        1)
          case "${_status[2]}" in
            .M)
              (( g[changed]++ ))
              ;;
            A.|M.)
              (( g[staged]++ ))
              ;;
          esac
          ;;
        2)
          case "${_status[2]}" in
            R.)
              (( g[changed]++ ))
              ;;
          esac
          ;;
      esac
    done < <($_git_command status --porcelain=2 --branch 2>&1)

    if (( g[changed] == 0 && g[conflicts] == 0 && g[staged] == 0 && g[untracked] == 0 )) ; then
      g[clean]="yes_but_no_value_to_show"
    fi

    __git_status[$_git_command]="$(typeset -p g)"
  }
  #----------
  function build_git_status() {
    local _git_command="${1:=git}"
    [[ "$_git_command" != "git" ]] && _zsh_git_prompt__update_vars "$_git_command"
    [[ -z "${__git_status[$_git_command]}" ]] && return
    eval "$__git_status[$_git_command]"
    (( g[no_repository] == 1 )) && return

    function __print() {
      local theme="${__git_theme[$1]}"
      local show="${__git_theme[show_${1}_count]}"
      local value="${g[$1]}"

      [[ -z "$theme" ]] && return
      [[ "${show:=1}" == "1" ]] || return
      [[ "$value" == "0" ]] && return
      echo -n "$theme"

      [[ -z "$value" || "$value" == "yes_but_no_value_to_show" ]] && return
      echo -n "$value"
    }

    for element in prefix branch behind ahead separator oid separator staged conflicts changed untracked clean suffix ; do
      __print $element
    done

    echo -n "%{${reset_color}%}"
  }
  #----------
fi
#-----------------------------------------------------------------------------
if (( $+commands[asdf] )) ; then
  typeset -g -A __preferred_languages=(
    ruby ruby
    nodejs node
  )
  #----------
  add-zsh-hook preexec _zsh_languages_prompt__preexec_hook
  add-zsh-hook chpwd _zsh_languages_prompt__chpwd_hook
  #----------
  function _zsh_languages_prompt__update_version() {
    local language="$1"
    read -r -A version < <(asdf current $language 2>|/dev/null)
    [[ -z "${version[1]}" || "${version[1]}" == "No" ]] && return
    __language_versions[$language]="${version[1]}"
  }
  #----------
  function _zsh_languages_prompt__preexec_hook() {
    local pre_cmd="${2/ */}"
    for language in ${(k)__preferred_languages[@]} ; do
      local language_cmd="${__preferred_languages[$language]}"
      [[ -n "$pre_cmd" && -n "$language_cmd" && "$pre_cmd" == "$language_cmd" ]] && _zsh_languages_prompt__update_version "$language"
    done
  }
  #----------
  function _zsh_languages_prompt__chpwd_hook() {
    if [[ -s "$PWD/.ruby-version" ]] ; then
      __language_versions[ruby]="$(<$PWD/.ruby-version)"
    elif [[ -s "$PWD/.node-version" ]] ; then
      __language_versions[nodejs]="$(<$PWD/.node-version)"
    elif [[ -s "$PWD/.tool-versions" ]] ; then
      __language_versions=(${=${(f)"$(<.tool-versions)"}})
    fi
  }
  #----------
fi
#-----------------------------------------------------------------------------
function build_left_prompt() {
  local _leading_space=""

  echo -n "%f%b%k%u%s"

  if [[ "$PWD" == "$HOME" ]] ; then
    if typeset -f build_git_status pubgit prvgit >&/dev/null ; then
      echo -n "%F{8}PUB:%f$(build_git_status pubgit)"
      echo -n " "
      echo -n "%F{8}PRV:%f$(build_git_status prvgit)"
      _leading_space=" "
    fi
  fi

  if [[ -n "$__preferred_languages" ]] ; then
    for language in ${(k)__preferred_languages[@]} ; do
      if [[ -n "${__language_versions[$language]}" ]] ; then
        echo -n "${_leading_space}%F{6}${language}-${__language_versions[$language]}"
        _leading_space=" "
      fi
    done
  fi

  if typeset -f build_git_status >&/dev/null ; then
    local _git_prompt="$(build_git_status)"
    if [[ -n "${_git_prompt}" ]] ; then
      echo -n "${_leading_space}%f${_git_prompt}"
      _leading_space=" "
    fi
  fi

  echo -n "${_leading_space}%F{7}%~\n"

  # Time
  echo -n '%F{8}%D{%H:%M:%S} '

  if am_i_someone_else ; then
    echo -n '%F{9}__%n__'
  else
    echo -n '%F{4}%n'
  fi

  # host
  if [[ -z $TMUX ]] ; then
    case $HOST in
      Shodan*)
        echo -n "%F{15}@%F{4}%m"
        ;;
      *)
        echo -n "%F{15}@%F{14}%m"
        ;;
    esac
  fi

  # path
  echo -n ' %(?.%F{7}.%F{15})%? %(!.#.$) '

  echo "%f%b%k%u%s"
}
#-----------------------------------------------------------------------------
# vim: set syntax=sh ft=zsh sw=2 ts=2 expandtab:

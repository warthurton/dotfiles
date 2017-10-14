#-----------------------------------------------------------------------------
for s in  ~/.shell-common \
          ~/.ghq/github.com/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh \
          ~/.ghq/github.com/zdharma/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh \
          ~/.fzf.zsh
do
  [[ -f "$s" ]] && source "$s"
done
#-----------------------------------------------------------------------------
export PROMPT="\$(build_left_prompt)"
export RPROMPT=""

alias -g M='|& $PAGER'
bindkey -e
bindkey -m 2>/dev/null

autoload -Uz compinit colors
compinit -C
colors
#-----------------------------------------------------------------------------
typeset -g -A __preferred_languages=(
  ruby .ruby-version
  nodejs .node-version
  elixir .elixir-version
)
typeset -g -A __language_versions

typeset -g -A __git_theme=(
  prefix "("
  suffix ")"
  separator "|"
  branch "%{$reset_color%}%{$fg_bold[magenta]%}"
  clean "%{$reset_color%}%{$fg_bold[green]%}%{✔%G%}"
  changed "%{$reset_color%}%{$fg[blue]%}%{✚%G%}"
  staged "%{$reset_color%}%{$fg[red]%}%{●%G%}"
  conflicts "%{$reset_color%}%{$fg[red]%}%{✖%G%}"
  oid "%{$reset_color%}%{$fg[gray]%}"
  ahead "%{$reset_color%}%{↑%G%}"
  behind "%{$reset_color%}%{↓%G%}"
  untracked "%{$reset_color%}%{…%G%}"
  show_changed_count 1
  show_staged_count 1
  show_conflict_count 1
  show_ahead_count 1
  show_behind_count 1
  show_untracked_count 0
)
typeset -g -A __git_status
#-----------------------------------------------------------------------------
function build_git_status() {
  (( $+commands[git] )) || return
  local _git_command="${1:=git}"
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
#-----------------------------------------------------------------------------
function _prompt__update_git() {
  (( $+commands[git] )) || return
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
#-----------------------------------------------------------------------------
function _prompt__update_language() {
  local plugin="$1"
  [[ -z "$plugin" ]] && return
  local version_file="$2"
  [[ -z "$version_file" ]] && return

  local version_env_var="ASDF_${(U)plugin}_VERSION"
  local version=${(P)version_env_var}

  if [[ -n "$version" ]] ; then
    __language_versions[$plugin]="$version"
    return
  fi

  local search_path="$PWD"

  while [[ "$search_path" != "/" ]] ; do
    local _version_file="${search_path}/${version_file}"

    if [[ -s "${_version_file}" ]] ; then
      __language_versions[$plugin]="$(<$_version_file)"
      return
    fi

    if [[ -s '.tool-versions' ]] ; then
      __language_versions=(${=${(f)"$(<.tool-versions)"}})
      return
    fi

    search_path=$(dirname "$search_path")
  done
}
#-----------------------------------------------------------------------------
function _prompt__update_languages() {
  (( $+commands[asdf] )) || return

  for plugin in ${(k)__preferred_languages[@]} ; do
    _prompt__update_language "$plugin" "${__preferred_languages[$plugin]}"
  done
}
#-----------------------------------------------------------------------------
function build_left_prompt() {
  local _leading_space=""

  _prompt__update_languages

  echo -n "%f%b%k%u%s"

  for plugin in ${(k)__preferred_languages[@]} ; do
    local version="${__language_versions[$plugin]}"

    if [[ -n "$version" ]] ; then
      echo -n "${_leading_space}%F{6}${plugin}-${version}"
      _leading_space=" "
    fi
  done

  if [[ "$PWD" == "$HOME" ]] && typeset -f pubgit prvgit >&/dev/null ; then
    _prompt__update_git pubgit .git-pub-dotfiles
    _prompt__update_git prvgit .git-prv-dotfiles

    echo -n "${_leading_space}%F{8}PUB:%f$(build_git_status pubgit)"
    echo -n " "
    echo -n "%F{8}PRV:%f$(build_git_status prvgit)"
    _leading_space=" "
  else
    _prompt__update_git git .git
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
if (( $+commands[direnv] )) ; then
  eval "$(direnv hook zsh)"
fi
#-----------------------------------------------------------------------------
if (( $+commands[fasd] )) ; then
  eval "$(fasd --init auto)"
fi
#-----------------------------------------------------------------------------
# vim: set syntax=sh ft=zsh sw=2 ts=2 expandtab:

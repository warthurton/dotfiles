#-----------------------------------------------------------------------------
for s in  ~/.shell-common \
          ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh \
          ~/.config/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh \
          ~/.fzf.zsh
do
  [[ -f "$s" ]] && source "$s"
#-----------------------------------------------------------------------------
export PROMPT="\$(build_left_prompt)"
export RPROMPT=""

alias -g M='| $PAGER'
bindkey -e
bindkey -m 2>/dev/null

autoload -Uz compinit colors
compinit -C
colors
done
#-----------------------------------------------------------------------------
# function powerline_precmd() {
#   # (valid choices: aws, cwd, docker, dotenv, exit, git, gitlite, hg, host, jobs, load, nix-shell, perlbrew, perms, root, shell-var, ssh, termtitle, time, user, venv, node)
#   # (default "venv,user,host,ssh,cwd,perms,git,hg,jobs,exit,root")
#
#   PS1="$(${GOPATH}/bin/powerline-go \
#       -numeric-exit-codes \
#       -error $? \
#       -shell zsh \
#       -modules time,node,cwd,perms,git,jobs,exit,root \
#       -path-aliases \~/code/tanium/connect=@CONNECT,\~/code=@CODE \
#       )"
# }
#
# function install_powerline_precmd() {
#   for s in "${precmd_functions[@]}"; do
#     if [ "$s" = "powerline_precmd" ]; then
#       return
#     fi
#   done
#   precmd_functions+=(powerline_precmd)
# }
#
# if [ "$TERM" != "linux" ]; then
#   install_powerline_precmd
# fi
#
#-----------------------------------------------------------------------------
typeset -g -A __preferred_languages=(
  ruby .ruby-version
  nodejs .node-version
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

  # Time
  echo -n "\n%F{8}%D{%H:%M:%S}"

  if am_i_someone_else ; then
    echo -n ' %F{9}__%n__'
  fi

  # host if remote
  if [[ -n $SSH_TTY ]] ; then
    echo -n " %F{15}@%F{14}%m"
  fi

  # path
  echo -n ' %F{7}%~ %(?.%F{7}.%F{15})%? %(!.#.$) '

  echo "%f%b%k%u%s"
}
#-----------------------------------------------------------------------------
if (( $+commands[nvm] )) ; then
  autoload -U add-zsh-hook
  load-nvmrc() {
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use
      fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
      echo "Reverting to nvm default version"
      nvm use default
    fi
  }
  add-zsh-hook chpwd load-nvmrc
  load-nvmrc
fi
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

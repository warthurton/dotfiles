#-----------------------------------------------------------------------------
alias -g M='|& $PAGER'
bindkey -e
bindkey -m 2>/dev/null

typeset -g -A git_theme

git_theme=(
  prefix "("
  suffix ")"
  separator "|"
  branch "%{$fg_bold[magenta]%}"
  clean "%{$fg_bold[green]%}%{✔%G%}"
  changed "%{$fg[blue]%}%{✚%G%}"
  staged "%{$fg[red]%}%{●%G%}"
  conflicts "%{$fg[red]%}%{✖%G%}"
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
#-----------------------------------------------------------------------------
for s in  ~/.shell-common \
          ~/.ghq/github.com/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh \
          ~/.ghq/github.com/zsh-users/zsh-completions/zsh-completions.plugin.zsh \
          ~/.ghq/github.com/zsh-users/zsh-history-substring-search/zsh-history-substring-search.zsh \
          ~/.ghq/github.com/robbyrussell/oh-my-zsh/plugins/safe-paste/safe-paste.plugin.zsh \
          ~/.ghq/github.com/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
          ~/.fzf.zsh
do
  [[ -f "$s" ]] && source "$s"
done
#-----------------------------------------------------------------------------
add-zsh-hook chpwd chpwd_update_git_vars
add-zsh-hook preexec preexec_update_git_vars
add-zsh-hook precmd precmd_update_git_vars

typeset -g -A GIT_STATUS

function preexec_update_git_vars() {
  unset __EXECUTED_GIT_COMMAND
  case "$2" in
    git*|hub*|gh*|stg*) __EXECUTED_GIT_COMMAND=1 ;;
  esac
}

function precmd_update_git_vars() {
  local _git_command="$1"
  [[ -z "$_git_command" ]] && _git_command="git"
  [[ "$__EXECUTED_GIT_COMMAND" == "1" || "$_git_command" != "git" ]] && update_current_git_vars "$_git_command"
}

function chpwd_update_git_vars() {
  local _git_command="$1"
  [[ -z "$_git_command" ]] && _git_command="git"
  update_current_git_vars "$_git_command"
}

function update_current_git_vars() {
  local _git_command="$1"
  [[ -z "$_git_command" ]] && _git_command="git"

  typeset -A g
  g=(staged 0 conflicts 0 changed 0 untracked 0 ignored 0 no_repository 0)

  while read -rA _status ; do
    case "${_status[1]}" in
      fatal*)
        g[no_repository]=1
        ;;
      \#)
        case "${_status[2]}" in
          branch.oid)
            g[oid]="${_status[3]}"
            ;;
          branch.head)
            g[branch]="${_status[3]}"
            ;;
          branch.upstream)
            g[upstream]="${_status[3]}"
            ;;
          branch.ab)
            g[ahead]="${_status[3]}"
            g[behind]="${_status[4]}"
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

  GIT_STATUS[$_git_command]="$(declare -p g)"
}

function print_git_theme_component() {
  local _component="$1"
  local _value="$2"

  [[ -z "${git_theme[$_component]}" ]] && return

  if (( _value != 0 )) ; then
    echo -n "${git_theme[$_component]}"
    if [[ "${git_theme[show_${_component}_count]}" -eq 1 ]] ; then
      echo -n "$_value"
    fi
    echo -n "%{${reset_color}%}"
  fi
}

function build_git_status() {
  local _git_command="$1"
  [[ -z "$_git_command" ]] && _git_command="git"

  precmd_update_git_vars "$_git_command"

  [[ -z "${GIT_STATUS[$_git_command]}" ]] && return

  eval "$GIT_STATUS[$_git_command]"

  (( g[no_repository] == 1 )) && return

  echo -n "${git_theme[prefix]}"
  echo -n "${git_theme[branch]}"
  echo -n "${g[branch]}"
  echo -n "%{${reset_color}%}"

  print_git_theme_component behind ${g[behind]}
  print_git_theme_component ahead ${g[ahead]}

  echo -n "${git_theme[separator]}"
  echo -n "%{${reset_color}%}"

  print_git_theme_component staged ${g[staged]}
  print_git_theme_component conflicts ${g[conflicts]}
  print_git_theme_component changed ${g[changed]}
  print_git_theme_component untracked ${g[untracked]}

  if (( g[changed] == 0 && g[conflicts] == 0 && g[staged] == 0 && g[untracked] == 0 )) ; then
    echo -n "${git_theme[clean]}"
    echo -n "%{${reset_color}%}"
  fi

  echo -n "${git_theme[suffix]}"
  echo -n "%{${reset_color}%}"
}

# --------------------------------------------------------------------------
function pretty_language_version() {
  local _language="$1"
  local _version

  [[ -n "$_language" ]] && command -v $_language >&/dev/null || return

  _version=$($_language --version)
  _version="${_version/v/}"

  case $_language in
    node)
      ;;
    ruby)
      _version="${_version/ruby /}"
      _version="${_version/ *}"
      ;;
    elixir)
      _version="${_version/Erlang*Elixir }"
      ;;
  esac

  echo "${_language}-${_version}"
}
#-----------------------------------------------------------------------------
function build_left_prompt() {
  echo -n "%f%b%k%u%s"

  for _language in ruby node elixir ; do
    local _v=$(pretty_language_version "$_language")
    [[ -n "${_v}" ]] && echo -n "%F{6}${_v} "
  done

  echo -n "%f$(build_git_status) "

  echo -n '%F{7}%~\n'

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

function build_right_prompt() {
  if declare -f pubgit >&/dev/null  ;then
    echo -n "%F{8}PUB %f$(build_git_status pubgit)"
    echo -n " | "
    echo -n "%F{8}PRV %f$(build_git_status prvgit)"
  fi
}

#-----------------------------------------------------------------------------
typeset -gi __PROMPT_PROC_LEFT=0
typeset -gi __PROMPT_PROC_RIGHT=0
typeset -g __PROMPT_FILE_LEFT="$HOME/.zsh_prompt_left_$$"
typeset -g __PROMPT_FILE_RIGHT="$HOME/.zsh_prompt_right_$$"
#-----------------------------------------------------------------------------
function precmd() {
  print -Pn "\e]0;\a"

  [[ "${__PROMPT_PROC_LEFT}" != 0 ]] && kill -s HUP $__PROMPT_PROC_LEFT >&/dev/null

  () {
    cp "$1" "$__PROMPT_FILE_LEFT"
    kill -s USR1 $$
  } =(build_left_prompt) &!
  __PROMPT_PROC_LEFT=$!
 
  [[ "${__PROMPT_PROC_RIGHT}" != 0 ]] && kill -s HUP $__PROMPT_PROC_RIGHT >&/dev/null

  () {
    cp "$1" "$__PROMPT_FILE_RIGHT"
    kill -s USR2 $$
  } =(build_right_prompt) &!
  __PROMPT_PROC_RIGHT=$!
}

function TRAPUSR1() {
  PROMPT="$(<$__PROMPT_FILE_LEFT)"
  rm -f "$__PROMPT_FILE_LEFT"
  __PROMPT_PROC_LEFT=0
  zle && zle reset-prompt
}

function TRAPUSR2() {
  RPROMPT="$(<$__PROMPT_FILE_RIGHT)"
  rm -f "$__PROMPT_FILE_RIGHT"
  __PROMPT_PROC_RIGHT=0
  zle && zle reset-prompt
}
#-----------------------------------------------------------------------------
# vim: set syntax=sh ft=zsh sw=2 ts=2 expandtab:

#-----------------------------------------------------------------------------
alias -g M='|& $PAGER'
bindkey -e
bindkey -m 2>/dev/null

autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit

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
  if [[ -f "$s" ]] ; then
    __time_start=$SECONDS
    source "$s"
    [[ $_debug_times ]] && simple_timer "source $s" $__time_start
  fi
done
#-----------------------------------------------------------------------------
autoload -Uz add-zsh-hook
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
  local _start=$SECONDS
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

  [[ $_debug_times ]] && simple_timer "update_current_git_vars $_git_command" $_start
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
  local _start=$SECONDS
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

  [[ $_debug_times ]] && simple_timer "build_git_status $_git_command" $_start
}
#-----------------------------------------------------------------------------
typeset -g -A __language_versions

function update_language_versions() {
  local -a languages=($*)
  local language
  local version
  local _start=$SECONDS

  for language in ${languages[@]} ; do
    (( $+commands[$language] )) || continue

    if (( $+commands[asdf] )) ; then
      read -r -A version < <(asdf current $language 2>|/dev/null)
      [[ -n "${version[1]}" ]] && __language_versions[$language]="${version[1]}"
    else
      read -r -A version < <($language --version 2>|/dev/null)
      case $language in
        ruby) [[ -n "${version[2]}" ]] && __language_versions[$language]="${version[2]}" ;;
        *) [[ -n "${version[1]}" ]] && __language_versions[$language]="${version[1]}" ;;
      esac
    fi
  done

  [[ $_debug_times ]] && simple_timer "update_language_versions" $_start
}
#-----------------------------------------------------------------------------
typeset -g -a __preferred_languages=(ruby node)
PERIOD=30

function periodic() {
  update_language_versions ${__preferred_languages[@]}
}
#-----------------------------------------------------------------------------
function build_left_prompt() {
  local _leading_space=""
  local _start=$SECONDS

  echo -n "%f%b%k%u%s"

  for language in ${__preferred_languages[@]} ; do
    if [[ -n "${__language_versions[$language]}" ]] ; then
      echo -n "${_leading_space}%F{6}${language}-${__language_versions[$language]}"
      _leading_space=" "
    fi
  done

  if (( $+commands[git] )) ; then
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
  [[ $_debug_times ]] && simple_timer "build_left_prompt" $_start
}

function build_right_prompt() {
  local _start=$SECONDS

  (( $+commands[git] )) && declare -f pubgit >&/dev/null || return
  echo -n "%F{8}PUB %f$(build_git_status pubgit)"
  echo -n " | "
  echo -n "%F{8}PRV %f$(build_git_status prvgit)"

  [[ $_debug_times ]] && simple_timer "build_right_prompt" $_start
}
#-----------------------------------------------------------------------------
typeset -g -a _prompt_procs
typeset -g _prompt_file_left="$HOME/.zsh_prompt_left_$$"
typeset -g _prompt_file_right="$HOME/.zsh_prompt_right_$$"
#-----------------------------------------------------------------------------
function precmd() {
  local _start=$SECONDS

  print -Pn "\e]0;\a"

  if [[ "${#_prompt_procs[@]}" -gt 0 ]] ; then
    kill -s HUP ${_prompt_procs[@]} >&/dev/null &!
    _prompt_procs=()
  fi

  () {
    cp "$1" "$_prompt_file_left"
    kill -s USR1 $$
  } =(build_left_prompt) &!
  _prompt_procs+=($!)

  () {
    cp "$1" "$_prompt_file_right"
    kill -s USR2 $$
  } =(build_right_prompt) &!
  _prompt_procs+=($!)

  [[ $_debug_times ]] && simple_timer "precmd" $_start
}

function TRAPUSR1() {
  PROMPT="$(<$_prompt_file_left)"
  rm -f "$_prompt_file_left"
  zle && zle reset-prompt >&/dev/null
}

function TRAPUSR2() {
  RPROMPT="$(<$_prompt_file_right)"
  rm -f "$_prompt_file_right"
  zle && zle reset-prompt >&/dev/null
}
#-----------------------------------------------------------------------------
# vim: set syntax=sh ft=zsh sw=2 ts=2 expandtab:

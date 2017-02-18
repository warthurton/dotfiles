#-----------------------------------------------------------------------------
alias -g M='|& $PAGER'
bindkey -e
bindkey -m 2>/dev/null
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

declare -A GIT_STATUS

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

  local -a _GIT

  __haskell="$HOME/.ghq/github.com/olivierverdier/zsh-git-prompt/src/.bin/gitstatus"

  [[ -x "$__haskell" ]] || return

  case "$_git_command" in
    pubgit)
      GIT_STATUS[$_git_command]=$(git --git-dir="$HOME/.git-pub-dotfiles" --work-tree="$HOME" status --porcelain --branch &> /dev/null | "${__haskell}")
      ;;
    prvgit)
      GIT_STATUS[$_git_command]=$(git --git-dir="$HOME/.git-prv-dotfiles" --work-tree="$HOME" status --porcelain --branch &> /dev/null | "${__haskell}")
      ;;
    *)
      GIT_STATUS[$_git_command]=$(git status --porcelain --branch &> /dev/null | "${__haskell}")
      ;;
  esac
}

function build_git_status() {
  local _git_command="$1"
  [[ -z "$_git_command" ]] && _git_command="git"

  precmd_update_git_vars "$_git_command"

  [[ -n "${GIT_STATUS[$_git_command]}" || "$_git_command" != "git" ]] || return

  local -a _GIT=("${(@s: :)GIT_STATUS[$_git_command]}")
  local GIT_BRANCH=$_GIT[1]
  local GIT_AHEAD=$_GIT[2]
  local GIT_BEHIND=$_GIT[3]
  local GIT_STAGED=$_GIT[4]
  local GIT_CONFLICTS=$_GIT[5]
  local GIT_CHANGED=$_GIT[6]
  local GIT_UNTRACKED=$_GIT[7]

  STATUS="$ZSH_THEME_GIT_PROMPT_PREFIX$ZSH_THEME_GIT_PROMPT_BRANCH${GIT_BRANCH}%{${reset_color}%}"

  [[ "${GIT_BEHIND}" -ne "0" ]] && \
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_BEHIND${GIT_BEHIND}%{${reset_color}%}"

  [[ "${GIT_AHEAD}" -ne "0" ]] && \
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD${GIT_AHEAD}%{${reset_color}%}"

  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_SEPARATOR"

  [[ "${GIT_STAGED}" -ne "0" ]] && \
     STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED${GIT_STAGED}%{${reset_color}%}"

  [[ "${GIT_CONFLICTS}" -ne "0" ]] && \
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CONFLICTS${GIT_CONFLICTS}%{${reset_color}%}"

  [[ "${GIT_CHANGED}" -ne "0" ]] && \
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CHANGED${GIT_CHANGED}%{${reset_color}%}"

  [[ "${GIT_UNTRACKED}" -ne "0" ]] && \
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED%{${reset_color}%}"

  [[ "${GIT_CHANGED}" -eq "0" ]] && [[ "${GIT_CONFLICTS}" -eq "0" ]] && [[ "${GIT_STAGED}" -eq "0" ]] && [[ "${GIT_UNTRACKED}" -eq "0" ]] && \
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"

  STATUS="$STATUS%{${reset_color}%}$ZSH_THEME_GIT_PROMPT_SUFFIX"

  echo "$STATUS"
}

#-----------------------------------------------------------------------------
# Prompt
export ZSH_THEME_GIT_PROMPT_PREFIX="("
export ZSH_THEME_GIT_PROMPT_SUFFIX=")"
export ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
export ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[magenta]%}"
export ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[red]%}%{●%G%}"
export ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}%{✖%G%}"
export ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[blue]%}%{✚%G%}"
export ZSH_THEME_GIT_PROMPT_BEHIND="%{↓%G%}"
export ZSH_THEME_GIT_PROMPT_AHEAD="%{↑%G%}"
export ZSH_THEME_GIT_PROMPT_UNTRACKED="%{…%G%}"
export ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}%{✔%G%}"
export PROMPT=""
export RPROMPT=""
declare ASYNC_LEFT_PROC=0
declare ASYNC_RIGHT_PROC=0
#-----------------------------------------------------------------------------
function build_left_prompt() {
  echo -n "%f%b%k%u%s"

  _export_pretty_language_versions

  for _language in ruby node elixir ; do
    _language_env="${(U)_language}_VERSION"
    [[ -n "${(P)_language_env}" ]] && \
      echo -n "%F{6}${_language}-${(P)_language_env} "
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
  if [[ "$PWD" == "$HOME" ]] ;then
    echo -n "%F{8}PUB %f$(build_git_status pubgit)"
    echo -n " | "
    echo -n "%F{8}PRV %f$(build_git_status prvgit)"
  fi
}

# Patterned from github.com/mafredri/zsh-async
function precmd() {
  print -Pn "\e]0;\a"

  function async_left_prompt() {
    printf "%s" "$(build_left_prompt)" > "$HOME/.z/left_prompt_$$"
    kill -s USR1 $$
  }

  function async_right_prompt() {
    printf "%s" "$(build_right_prompt)" > "$HOME/.z/right_prompt_$$"
    kill -s USR2 $$
  }

  if [[ "${ASYNC_LEFT_PROC}" != 0 ]]; then
    kill -s HUP $ASYNC_LEFT_PROC >/dev/null 2>&1 || :
  fi

  if [[ "${ASYNC_RIGHT_PROC}" != 0 ]]; then
    kill -s HUP $ASYNC_RIGHT_PROC >/dev/null 2>&1 || :
  fi

  async_left_prompt &!
  ASYNC_LEFT_PROC=$!
  async_right_prompt &!
  ASYNC_RIGHT_PROC=$!
}

function TRAPUSR1() {
  PROMPT="$(cat $HOME/.z/left_prompt_$$)"
  ASYNC_LEFT_PROC=0
  zle && zle reset-prompt
}

function TRAPUSR2() {
  RPROMPT="$(cat $HOME/.z/right_prompt_$$)"
  ASYNC_RIGHT_PROC=0
  zle && zle reset-prompt
}
#-----------------------------------------------------------------------------
# vim: set syntax=sh ft=zsh sw=2 ts=2 expandtab:

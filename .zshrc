# --------------------------------------------------------------------------
alias -g M='|& $PAGER'
bindkey -e
bindkey -m 2>/dev/null
# --------------------------------------------------------------------------
for s in  ~/.shell-common \
          ~/.config/zsh-history-substring-search/zsh-history-substring-search.zsh \
          ~/.config/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
          ~/.config/oh-my-zsh/plugins/safe-paste/safe-paste.plugin.zsh \
          ~/.config/zsh-git-prompt/zshrc.sh \
          ~/.config/zsh-autosuggestions/zsh-autosuggestions.zsh \
          ~/.fzf.zsh
do
  [[ -f "$s" ]] && source "$s"
done
# ---------------------------------------------------------------------------
predate() {
  while read -r line ; do
    strftime "%F %T $line\n" "$EPOCHSECONDS"
  done
}
# --------------------------------------------------------------------------
zstyle ':completion::complete:*' use-cache on
zstyle ':vcs_info:*' check-for-changes false
compinit
bashcompinit

#-----------------------------------------------------------------------------
_ruby_version() {
  local raw

  if (( $+commands[ruby] )) ; then
    raw=$(ruby --version)
    export RUBY_VERSION="${${raw/ruby /}/ *}"

    echo -n "${_RUBY/ */}"
  fi
}

_node_version() {
  local raw

  if (( $+commands[node] )) ; then
    raw=$(node --version)
    export NODE_VERSION="${raw/v/}"

    echo -n "${_node/ */}"
  fi
}


_darwin_unlocked() {
  export DARWIN_UNLOCKED=""

  if [[ "${OSTYPE:0:6}" = "darwin" && $USER != "root" && $(defaults read com.apple.screensaver askForPassword) != "1" ]] ; then
    export DARWIN_UNLOCKED="\U1F513"
  fi
}

precmd() {
  if (( $RANDOM % 10 )) ; then  # These updates don't need to run every time.
    _darwin_unlocked
    _ruby_version
    _node_version
  fi
  print -Pn "\e]0;\a"
}

build_multi_prompt() {
  # security
  [[ -n $DARWIN_UNLOCKED ]] && echo -n "%F{11}${DARWIN_UNLOCKED} "

  # ruby
  [[ -n $RUBY_VERSION ]] && echo -n "%F{6}rb-${RUBY_VERSION} "

  # elixir
  [[ -n "$ELIXIR_VERSION" ]] && echo -n "%F{6}ex-${ELIXIR_VERSION} "

  # nodejs
  [[ -n "$NODE_VERSION" ]] && echo -n "%F{6}js-${NODE_VERSION} "

  echo -n "%f$(git_super_status) "

  echo -n '%F{7}%~\n'

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

export PROMPT="%f%b%k%u%s\$(build_multi_prompt)%f%b%k%u%s"
unset RPROMPT

# --------------------------------------------------------------------------
# vim: set syntax=sh ft=zsh sw=2 ts=2 expandtab:

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
_oh_my_plugins="~/.config/oh-my-zsh/plugins"

if [[ -d "${_oh_my_plugins}" ]] ; then
  while read -r _zsh_completion_file ; do
    
  done < <(find "${_oh_my_plugins}" -type f -name '_*')
fi

# predate() {
#   while read -r line ; do
#     strftime "%F %T $line\n" "$EPOCHSECONDS"
#   done
# }

#-----------------------------------------------------------------------------
_pretty_language_version() {
  local _language="$1"
  local _version

  (( $+commands[$_language] )) || return

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

  echo "$_version"
}

#-----------------------------------------------------------------------------
_export_pretty_language_versions() {
  local _version
  local _language_export

  for _language in ruby node elixir ; do
    _version=$(_pretty_language_version "$_language")
    _language_export="${(U)_language}_VERSION=\"${_version}\""
    eval "$_language_export"
  done
}

precmd() {
  (( $RANDOM % 10 )) && _export_pretty_language_versions
  print -Pn "\e]0;\a"
}

build_multi_prompt() {
  for _language in ruby node elixir ; do
    _language_env="${(U)_language}_VERSION"
    [[ -n "${(P)_language_env}" ]] && \
      echo -n "%F{6}${_language}-${(P)_language_env} "
  done

  command -v git_super_status > /dev/null && echo -n "%f$(git_super_status) "

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

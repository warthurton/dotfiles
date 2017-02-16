# --------------------------------------------------------------------------
alias -g M='|& $PAGER'
bindkey -e
bindkey -m 2>/dev/null
# --------------------------------------------------------------------------
for s in  ~/.shell-common \
          ~/.ghq/github.com/olivierverdier/zsh-git-prompt/zshrc.sh \
          ~/.ghq/github.com/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh \
          ~/.ghq/github.com/zsh-users/zsh-completions/zsh-completions.plugin.zsh \
          ~/.ghq/github.com/zsh-users/zsh-history-substring-search/zsh-history-substring-search.zsh \
          ~/.ghq/github.com/robbyrussell/oh-my-zsh/plugins/safe-paste/safe-paste.plugin.zsh \
          ~/.ghq/github.com/b4b4r07/emoji-cli/emoji-cli.zsh \
          ~/.ghq/github.com/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
          ~/.fzf.zsh
do
  [[ -f "$s" ]] && source "$s"
done

#-----------------------------------------------------------------------------
precmd() {
  (( $RANDOM % 50 )) && _export_pretty_language_versions
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
}

export PROMPT="%f%b%k%u%s\$(build_multi_prompt)%f%b%k%u%s"
unset RPROMPT
# --------------------------------------------------------------------------
# vim: set syntax=sh ft=zsh sw=2 ts=2 expandtab:

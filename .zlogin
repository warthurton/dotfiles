{
  for script in \
      ~/.fzf.zsh \
      ~/.shell-common \
      ~/.shell-env \
      ~/.shell-path \
      ~/.shell-prv \
      ~/.zcompdump \
      ~/.zlogin \
      ~/.zprofile \
      ~/.zshenv \
      ~/.zshrc \
      ~/.ghq/github.com/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh \
      ~/.ghq/github.com/zsh-users/zsh-completions/zsh-completions.plugin.zsh \
      ~/.ghq/github.com/zsh-users/zsh-history-substring-search/zsh-history-substring-search.zsh \
      ~/.ghq/github.com/robbyrussell/oh-my-zsh/plugins/safe-paste/safe-paste.plugin.zsh \
      ~/.ghq/github.com/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  do
    [[ -s "$script" && ( ! -s "${script}.zwc" || "$script" -nt "${script}.zwc") ]] && zcompile "$script" &!
  done

} &!

{
  find "$HOME" -type f -maxdepth 1 -name '.zsh_prompt_*' -delete
} &!

# vim: set syntax=zsh ft=sh sw=2 ts=2 expandtab:

{
  zcompdump="$HOME/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

{
  find "$HOME" -type f -maxdepth 1 -name '.zsh_prompt_*' -delete
} &!

# vim: set syntax=zsh ft=sh sw=2 ts=2 expandtab:

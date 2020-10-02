#-----------------------------------------------------------------------------
typeset -g PROMPT='%f%b%k%u%s%n@%m %~ %(!.#.$)%f%b%k%u%s '
typeset -g RPROMPT=''
#-----------------------------------------------------------------------------

zmodload zsh/compctl \
         zsh/complete \
         zsh/complist \
         zsh/datetime \
         zsh/main \
         zsh/parameter \
         zsh/terminfo \
         zsh/zle \
         zsh/zleparameter \
         zsh/zutil

#-----------------------------------------------------------------------------
fpath+=("$HOME/.config/zsh/site-functions")
#-----------------------------------------------------------------------------
for s in ~/.shell-path ~/.shell-env ; do
  [[ -f "$s" ]] && source "$s"
done
#-----------------------------------------------------------------------------
# vim: set syntax=zsh ft=zsh sw=2 ts=2 expandtab:

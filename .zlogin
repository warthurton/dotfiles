#-----------------------------------------------------------------------------
autoload -U zrecompile && zrecompile -q -p \
  ~/.shell-common -- \
  ~/.shell-env -- \
  ~/.shell-path -- \
  ~/.shell-prv -- \
  ~/.zcompdump -- \
  ~/.zlogin -- \
  ~/.zprofile -- \
  ~/.zshenv -- \
  ~/.zshrc -- &!
#-----------------------------------------------------------------------------
# vim: set syntax=zsh ft=sh sw=2 ts=2 expandtab:

#-----------------------------------------------------------------------------
for s in ~/.shell-common \
    ~/.fzf.zsh \
    ~/.config/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh \
    ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
do
  [[ -f "$s" ]] && source "$s"
done
#-----------------------------------------------------------------------------
typeset -g -a _preferred_languages=(ruby node python2 python3)

alias -g M='| $PAGER'
(( $+commands[bat] )) && alias -g B='| bat'
bindkey -e
bindkey -m 2>/dev/null

autoload -Uz compinit && compinit -C
#-----------------------------------------------------------------------------
autoload -Uz zcalc
__calc() {
  zcalc -e "$*"
}
aliases[=]='noglob __calc'
#-----------------------------------------------------------------------------
if (( $+commands[direnv] )) ; then
  eval "$(direnv hook zsh)"
fi
#-----------------------------------------------------------------------------
if (( $+commands[fasd] )) ; then
  eval "$(fasd --init auto)"
fi
#-----------------------------------------------------------------------------
autoload -U promptinit
promptinit
prompt chorn
#-----------------------------------------------------------------------------
# vim: set syntax=zsh ft=zsh sw=2 ts=2 expandtab:

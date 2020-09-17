#-----------------------------------------------------------------------------
# typeset -g _debug_times
# typeset -F SECONDS

# _debug_timer() {
#   [[ -z "$_debug_times" ]] && return
#   local _what="$1"
#   local _start="$2"
#   print -f "%d %2.3f %s\n" $$ $(( SECONDS - _start )) "$_what" >> ~/zsh_debug_timer
# }
#
# _debug_before() {
#   _debug_timer "before $*"
# }
#
# _debug_after() {
#   _debug_timer "after $*"
# }
#
# _debug_source() {
#   _debug_before "source $*"
#   source "$*"
#   _debug_after "source $*"
# }
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
  # [[ -f "$s" ]] && _debug_source "$s"
  [[ -f "$s" ]] && source "$s"
done
#-----------------------------------------------------------------------------
# vim: set syntax=zsh ft=zsh sw=2 ts=2 expandtab:

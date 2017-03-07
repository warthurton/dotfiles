#-----------------------------------------------------------------------------
typeset -g HISTFILE="$HOME/.zhistory"
typeset -g SAVEHIST=10000000
typeset -g WORDCHARS='*?_-.[]~&;!#$%^(){}<>'
typeset -g _debug_times
typeset -F SECONDS
skip_global_compinit=1
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

if [[ "$ZSH_VERSION[1]" -gt 4 ]] ; then
  zmodload zsh/system
  setopt inc_append_history_time
fi
#-----------------------------------------------------------------------------
setopt auto_cd \
       cdable_vars \
       always_to_end \
       auto_list \
       auto_menu \
       auto_param_slash \
       complete_in_word \
       hash_list_all \
       list_ambiguous \
       nolist_beep \
       list_packed \
       list_types \
       nomenu_complete \
       brace_ccl \
       case_glob \
       extended_glob \
       path_dirs \
       append_history \
       bang_hist \
       extended_history \
       hist_allow_clobber \
       hist_expire_dups_first \
       hist_fcntl_lock \
       nohist_find_no_dups \
       nohist_ignore_all_dups \
       hist_ignore_space \
       hist_no_store \
       hist_reduce_blanks \
       hist_verify \
       noinc_append_history \
       noshare_history \
       clobber \
       nocorrect \
       nocorrect_all \
       noflow_control \
       interactive_comments \
       nomail_warning \
       noauto_resume \
       nobg_nice \
       check_jobs \
       nohup \
       long_list_jobs \
       nonotify \
       prompt_subst \
       multios \
       posix_builtins \
       nobeep \
       combining_chars \
       emacs

#-----------------------------------------------------------------------------
function debug_timer() {
  [[ -z "$_debug_times" ]] && return
  local _what="$1"
  local _start="$2"
  print -f "%d %2.3f %s\n" $$ $(( SECONDS - _start )) "$_what" >> ~/zsh_debug_timer
}
#-----------------------------------------------------------------------------
for s in ~/.shell-path ~/.shell-env ; do
  if [[ -f "$s" ]] ; then
    __start=$SECONDS
    source "$s"
    debug_timer "source $s" $__start
  fi
done
#-----------------------------------------------------------------------------
# vim: set syntax=sh ft=zsh sw=2 ts=2 expandtab:

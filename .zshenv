#-----------------------------------------------------------------------------
export HISTFILE="$HOME/.zhistory"
export SAVEHIST=10000000
export WORDCHARS='*?_-.[]~&;!#$%^(){}<>'
skip_global_compinit=1
#-----------------------------------------------------------------------------
zmodload  zsh/compctl \
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
typeset -F SECONDS
typeset -g _debug_times=0

function simple_timer() {
  local _what="$1"
  local _start="$2"
  print -f "%d %2.3f %s\n" $$ $(( SECONDS - _start )) "$_what" >> ~/simple_timer
}
#-----------------------------------------------------------------------------
for s in ~/.shell-path ~/.shell-env ; do
  if [[ -f "$s" ]] ; then
    # __time_start=$SECONDS
    source "$s"
    # [[ $_debug_times ]] && simple_timer "source $s" $__time_start
  fi
done
#-----------------------------------------------------------------------------
fpath=($HOME/.ghq/github.com/zsh-users/zsh-completions/src $fpath)

_oh_my_plugins="$HOME/.ghq/github.com/robbyrussell/oh-my-zsh/plugins"

if [[ -d "${_oh_my_plugins}" ]] ; then
  # __time_start=$SECONDS

  while read -r _zsh_completion_file ; do
    _file="$(basename "$_zsh_completion_file")"
    _cmd="${_file##_}"
    if (( $+commands[$_cmd] )) ; then
      _dir="$(dirname "$_zsh_completion_file")"
      fpath=(${_dir} $fpath)
    fi
  done < <(find "${_oh_my_plugins}" -type f -name '_*')

  # [[ $_debug_times ]] && simple_timer "add oh-my-zsh completions" $__time_start
fi

typeset -gU fpath path

#-----------------------------------------------------------------------------
# vim: set syntax=sh ft=zsh sw=2 ts=2 expandtab:

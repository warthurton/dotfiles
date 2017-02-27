# --------------------------------------------------------------------------
export HISTFILE="$HOME/.zhistory"
export SAVEHIST=10000000 # The maximum number of events to save in the history file.
export WORDCHARS='*?_-.[]~&;!#$%^(){}<>'
skip_global_compinit=1
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
    __time_start=$SECONDS
    source "$s"
    [[ $_debug_times ]] && simple_timer "source $s" $__time_start
  fi
done
#-----------------------------------------------------------------------------
fpath=($HOME/.ghq/github.com/zsh-users/zsh-completions/src $fpath)

_oh_my_plugins="$HOME/.ghq/github.com/robbyrussell/oh-my-zsh/plugins"

if [[ -d "${_oh_my_plugins}" ]] ; then
  __time_start=$SECONDS

  while read -r _zsh_completion_file ; do
    _file="$(basename "$_zsh_completion_file")"
    _cmd="${_file##_}"
    if (( $+commands[$_cmd] )) ; then
      _dir="$(dirname "$_zsh_completion_file")"
      fpath=(${_dir} $fpath)
    fi
  done < <(find "${_oh_my_plugins}" -type f -name '_*')

  [[ $_debug_times ]] && simple_timer "add oh-my-zsh completions" $__time_start
fi

typeset -gU fpath path

#-----------------------------------------------------------------------------
__time_start=$SECONDS

zmodload zsh/compctl
zmodload zsh/complete
zmodload zsh/complist
zmodload zsh/datetime
zmodload zsh/main
zmodload zsh/parameter
zmodload zsh/system
zmodload zsh/terminfo
zmodload zsh/zle
zmodload zsh/zleparameter
zmodload zsh/zutil

[[ $_debug_times ]] && simple_timer "zmodload" $__time_start

__time_start=$SECONDS

autoload -Uz colors && colors

[[ $_debug_times ]] && simple_timer "colors" $__time_start

#-----------------------------------------------------------------------------
# Changing Directories
setopt auto_cd                # Auto changes to a directory without typing cd.
setopt cdable_vars            # Change directory to a path stored in a variable.

# Completion
setopt always_to_end          # Move cursor to the end of a completed word.
setopt auto_list              # Automatically list choices on ambiguous completion.
setopt auto_menu              # Show completion menu on a succesive tab press.
setopt auto_param_slash       # If completed parameter is a directory, add a trailing slash.
setopt complete_in_word       # Complete from both ends of a word.
setopt hash_list_all
setopt list_ambiguous
unsetopt list_beep
setopt list_packed
setopt list_types
unsetopt menu_complete        # Do not autoselect the first completion entry.

# Expansion and Globbing
setopt brace_ccl
setopt case_glob
setopt extended_glob          # Use extended globbing syntax.
setopt path_dirs              # Perform path search even on command names with slashes.

# History
setopt append_history
setopt bang_hist              # Treat the '!' character specially during expansion.
setopt extended_history       # Write the history file in the ':start:elapsed;command' format.
setopt hist_allow_clobber
setopt hist_expire_dups_first # Expire a duplicate event first when trimming history.
setopt hist_fcntl_lock
unsetopt hist_find_no_dups    # Do not display a previously found event.
unsetopt hist_ignore_all_dups # Delete an old recorded event if a new event is a duplicate.
setopt hist_ignore_space
setopt hist_no_store
setopt hist_reduce_blanks
setopt hist_verify            # Do not execute immediately upon history expansion.
unsetopt inc_append_history     # A) Pick
unsetopt share_history          # B) only
setopt inc_append_history_time  # C) one

# Input/Output
setopt clobber
unsetopt correct
unsetopt correct_all
unsetopt flow_control
setopt interactive_comments
unsetopt mail_warning

# Job Control
unsetopt auto_resume          # Attempt to resume existing job before creating a new process.
unsetopt bg_nice              # Don't run all background jobs at a lower priority.
setopt check_jobs             # Report on jobs when shell exit.
unsetopt hup                  # Don't kill jobs on shell exit.
setopt long_list_jobs         # List jobs in the long format by default.
unsetopt notify               # Report status of background jobs immediately.

# Promping
setopt prompt_subst

# Scripts and Functions
setopt multios                # Write to multiple descriptors.
setopt posix_builtins

# Zle
unsetopt beep
setopt combining_chars        # Combine zero-length punctuation characters (accents) with the base character.
setopt emacs

# --------------------------------------------------------------------------
# vim: set syntax=sh ft=zsh sw=2 ts=2 expandtab:

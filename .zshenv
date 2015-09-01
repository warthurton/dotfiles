# --------------------------------------------------------------------------
export HISTFILE="$HOME/.zhistory"
export SAVEHIST=10000000 # The maximum number of events to save in the history file.
export WORDCHARS='*?_-.[]~&;!#$%^(){}<>'
unset MULTIBYTE
# --------------------------------------------------------------------------
[[ -f "$HOME/.shell-env" ]] && source "$HOME/.shell-env"

fpath=(~/.zsh/zsh-completions/src $fpath)
typeset -gU fpath path

# --------------------------------------------------------------------------
autoload -Uz colors && colors
autoload -Uz compinit
autoload -Uz bashcompinit
autoload -Uz vcs_info
autoload -Uz zmv
autoload -Uz zcp
autoload -Uz zed
autoload -Uz zargs

zmodload zsh/compctl
zmodload zsh/complete
zmodload zsh/complist
zmodload zsh/datetime
zmodload zsh/main
zmodload zsh/parameter
zmodload zsh/zle
zmodload zsh/zleparameter
zmodload zsh/zutil
zmodload zsh/terminfo
# --------------------------------------------------------------------------
setopt nobeep
setopt auto_param_slash       # If completed parameter is a directory, add a trailing slash.
setopt noauto_resume          # Attempt to resume existing job before creating a new process.
setopt nobg_nice              # Don't run all background jobs at a lower priority.
setopt brace_ccl              # Allow brace character class list expansion.
setopt case_glob              #
setopt cdable_vars            # Change directory to a path stored in a variable.
setopt check_jobs             # Report on jobs when shell exit.
setopt clobber                #
setopt nocorrect
setopt nocorrect_all
setopt emacs
setopt extended_glob          # Use extended globbing syntax.
setopt nohup                  # Don't kill jobs on shell exit.
setopt long_list_jobs         # List jobs in the long format by default.
setopt multios                # Write to multiple descriptors.
setopt nomail_warning         # Don't print a warning message if a mail file has been accessed.
setopt nonotify               # Report status of background jobs immediately.
setopt path_dirs              # Perform path search even on command names with slashes.
setopt prompt_subst           #
# History
setopt append_history
setopt bang_hist              # Treat the '!' character specially during expansion.
setopt extended_history       # Write the history file in the ':start:elapsed;command' format.
setopt noflow_control         # Disable start/stop characters in shell editor.
setopt hist_expire_dups_first # Expire a duplicate event first when trimming history.
setopt hist_ignore_space
setopt hist_verify            # Do not execute immediately upon history expansion.
setopt nohist_find_no_dups    # Do not display a previously found event.
setopt nohist_ignore_all_dups # Delete an old recorded event if a new event is a duplicate.
setopt hist_ignore_dups       # Do not record an event that was just recorded again.
setopt hist_reduce_blanks
setopt hist_save_no_dups      # Do not write a duplicate event to the history file.
setopt inc_append_history     # Write to the history file immediately, not when the shell exits.
setopt share_history          # Share history between all sessions.
# Completion
setopt always_to_end          # Move cursor to the end of a completed word.
setopt auto_cd                # Auto changes to a directory without typing cd.
setopt auto_list              # Automatically list choices on ambiguous completion.
setopt auto_menu              # Show completion menu on a succesive tab press.
setopt combining_chars        # Combine zero-length punctuation characters (accents) with the base character.
setopt complete_in_word       # Complete from both ends of a word.
setopt list_ambiguous
setopt list_types
setopt nomenu_complete        # Do not autoselect the first completion entry.
# --------------------------------------------------------------------------
# vim: set syntax=sh ft=zsh sw=2 ts=2 expandtab:

# --------------------------------------------------------------------------
# Interactive shells only
# --------------------------------------------------------------------------
autoload -Uz colors && colors
autoload -Uz compinit
autoload -Uz vcs_info
autoload -Uz zmv
autoload -Uz zcp
autoload -Uz zed
autoload -Uz zargs

zmodload -i zsh/compctl
zmodload -i zsh/complete
zmodload -i zsh/complist
zmodload -i zsh/datetime
zmodload -i zsh/main
zmodload -i zsh/parameter
zmodload -i zsh/zle
zmodload -i zsh/zleparameter
zmodload -i zsh/zutil
zmodload -i zsh/terminfo
# --------------------------------------------------------------------------
alias -g M='|& $PAGER'

export HISTFILE="$HOME/.zhistory"
export SAVEHIST=10000000 # The maximum number of events to save in the history file.
export WORDCHARS='*?_-.[]~&;!#$%^(){}<>'
# --------------------------------------------------------------------------
setopt nobeep
setopt append_history
setopt auto_param_slash       # If completed parameter is a directory, add a trailing slash.
setopt noauto_resume            # Attempt to resume existing job before creating a new process.
setopt bang_hist              # Treat the '!' character specially during expansion.
setopt nobg_nice              # Don't run all background jobs at a lower priority.
setopt brace_ccl              # Allow brace character class list expansion.
setopt case_glob              #
setopt cdable_vars            # Change directory to a path stored in a variable.
setopt check_jobs             # Don't report on jobs when shell exit.
setopt clobber                #
setopt nocorrect
setopt nocorrect_all
setopt emacs
setopt extended_glob          # Use extended globbing syntax.
setopt extended_history       # Write the history file in the ':start:elapsed;command' format.
setopt noflow_control           # Disable start/stop characters in shell editor.
setopt hist_expire_dups_first # Expire a duplicate event first when trimming history.
setopt hist_ignore_space
setopt hist_verify            # Do not execute immediately upon history expansion.
setopt nohist_find_no_dups      # Do not display a previously found event.
setopt nohist_ignore_all_dups   # Delete an old recorded event if a new event is a duplicate.
setopt nohist_ignore_dups       # Do not record an event that was just recorded again.
setopt hist_save_no_dups      # Do not write a duplicate event to the history file.
setopt nohup                    # Don't kill jobs on shell exit.
setopt inc_append_history     # Write to the history file immediately, not when the shell exits.
setopt interactive_comments
setopt long_list_jobs         # List jobs in the long format by default.
setopt multios                # Write to multiple descriptors.
setopt nomail_warning         # Don't print a warning message if a mail file has been accessed.
setopt nonotify               # Report status of background jobs immediately.
setopt noshare_history        # Share history between all sessions.
setopt path_dirs              # Perform path search even on command names with slashes.
setopt prompt_subst           #
setopt pushd_ignore_dups      # Do not store duplicates in the stack.
setopt pushd_silent           # Do not print the directory stack after pushd or popd.
setopt pushd_to_home          # Push to home directory when no argument is given.
setopt rc_quotes              # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'.
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
for s in ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh ~/.iterm2.zsh ~/.shell-common ~/.fzf.zsh ; do
  [[ -f "$s" ]] && source "$s"
done
# --------------------------------------------------------------------------
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# bind P and N for EMACS mode
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# --------------------------------------------------------------------------
zstyle ':completion::complete:*' use-cache on
compinit
# --------------------------------------------------------------------------
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr ' %F{10}\U03B4%f'
zstyle ':vcs_info:*' unstagedstr ' %F{11}\U03B4%f'

__vcs_info_git_format='%c%u %b %F{8}%6.6i%f %m'

zstyle ':vcs_info:git*' formats "${__vcs_info_git_format}"
zstyle ':vcs_info:git*' actionformats " %F{15}%a%f ${__vcs_info_git_format}"
zstyle ':vcs_info:git*+set-message:*' hooks git-status

function +vi-git-status() {
  local branch
  branch="${hook_com[branch]}"

  local -i last_commit
  local -i minutes_since_last_commit
  strftime -s last_commit '%s' $(git log --pretty=format:'%at' -1)
  minutes_since_last_commit=$(( ($EPOCHSECONDS - last_commit) / 60))

  if (( minutes_since_last_commit > 90 )) ; then
    hook_com[branch]="%F{9}${branch}%f"
    hook_com[unstaged]+=" %F{9}${minutes_since_last_commit}m%f"
  elif (( minutes_since_last_commit > 30 )) ; then
    hook_com[branch]="%F{3}${branch}%f"
    hook_com[unstaged]+=" %F{3}${minutes_since_last_commit}m%f"
  else
    hook_com[branch]="%F{2}${branch}%f"
  fi

  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && git status --porcelain | fgrep '??' &> /dev/null ; then
    hook_com[unstaged]+=' %F{13}?%f'
  fi

  local remote=${$(git rev-parse --verify ${branch}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

  if [[ -n ${remote} ]] ; then
    local -i ahead
    local -i behind
    local -a gitstatus

    [[ ${remote#*/} != ${branch} ]] && gitstatus+=(${remote})

    ahead=$(git rev-list ${branch}@{upstream}..HEAD 2>/dev/null | wc -l)
    (( ahead )) && gitstatus+=( "%F{2}+${ahead}%f" )

    behind=$(git rev-list HEAD..${branch}@{upstream} 2>/dev/null | wc -l)
    (( behind )) && gitstatus+=( "%F{5}-${behind}%f" )

    (( ${#gitstatus} > 0 )) && hook_com[branch]+=" %F{8}[%f${(j: :)gitstatus}%F{8}]%f"
  fi

  local -i stashes
  if [[ -s ${hook_com[base]}/.git/refs/stash ]] ; then
    stashes=$(git stash list 2>/dev/null | wc -l)
    hook_com[misc]+=" %F{7}(${stashes} stashed)%f"
  fi
}

#-----------------------------------------------------------------------------
_ruby_version() {
  local raw

  if (( $+commands[ruby] )) ; then
    raw=$(ruby --version)
    export RUBY_VERSION="${${raw/ruby /ruby-}/ *}"

    echo -n "${_RUBY/ */}"
  fi
}

precmd() {
  vcs_info
  _ruby_version
}

build_lprompt() {
  # user
  echo -n '%(!.%F{9}.%F{4})%n'
  [[ -n $RUBY_VERSION ]] && echo -n " %F{1}${RUBY_VERSION}"

  echo -n "%f${vcs_info_msg_0_%% }"

  # path
  echo -n ' %F{7}%~ %(?.%F{7}.%F{15})%? %(!.#.$) '
}

build_rprompt() {
  [[ -z $TMUX ]] || return

  # host
  echo -n '%F{8}%m'

  # security
  if [[ "${OSTYPE:0:6}" = "darwin" && $USER != "root" ]] ; then
    if [[ $(defaults read com.apple.screensaver askForPassword) != "1" ]] ; then
      echo -n ' %F{11}unlocked'
    fi
  fi

  # Time
  echo -n ' %F{8}%D{%H:%M:%S}'
}

export PROMPT="%f%b%k%u%s\$(build_lprompt)%f%b%k%u%s"
export RPROMPT="%f%b%k%u%s\$(build_rprompt)%f%b%k%u%s"

#-----------------------------------------------------------------------------
if [ "${OSTYPE:0:6}" = "darwin" ] ; then
  declare -i _ssh_major_ver
  declare -i _ssh_minor_ver
  ssh -V 2>&1 | sed -e 's/^[a-zA-Z]*_\([1-9][0-9]*\)\.\([0-9][0-9]*\).*$/\1 \2/' | read _ssh_major_ver _ssh_minor_ver

  if (( (_ssh_major_ver = 6 && _ssh_minor_ver >= 6) || _ssh_major_ver >= 7 )) ; then
    ssh-add -l -M >&/dev/null
  fi
fi
# --------------------------------------------------------------------------
# vim: ft=zsh sw=2 ts=2 et

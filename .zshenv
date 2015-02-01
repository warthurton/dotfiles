# --------------------------------------------------------------------------
umask 022

path=(
  $HOME/bin
  /Applications/VMware\ Fusion.app/Contents/Library
  /Applications/Postgres.app/Contents/Versions/9.4/bin
  /{usr,opt}/{local,X11}/{bin,sbin}
  $path
  /{usr,opt}/{bin,sbin}
  /{bin,sbin}
)

fpath=(~/.zsh/zsh-completions/src $fpath)

typeset -gU fpath path

# __PATH=""
# while read -d : p ; do
#   [[ -d "${p}" ]] && __PATH="${__PATH}:${p}"
# done < <(echo $PATH)
# export PATH=${__PATH#:}

# [[ -f "$HOME/.certs/curl-cacert.pem" ]] && export CURL_CA_BUNDLE="$HOME/.certs/curl-cacert.pem"

# --------------------------------------------------------------------------
if [[ -d "/usr/local/opt/rbenv/bin" ]] ; then
  export RBENV_ROOT="/usr/local/opt/rbenv"
elif [[ -d "$HOME/.rbenv/bin" ]] ; then
  export RBENV_ROOT="$HOME/.rbenv"
elif [[ -d "$HOME/.rvm/bin" ]] ; then
  export PATH="$PATH:$HOME/.rvm/bin"
  source "$HOME/.rvm/scripts/rvm"
fi

if [[ -n $RBENV_ROOT ]] ; then
  export PATH="$PATH:$RBENV_ROOT/bin"
  eval "$(rbenv init - zsh)"
fi

# --------------------------------------------------------------------------
# vim: ft=zsh sw=2 ts=2 et

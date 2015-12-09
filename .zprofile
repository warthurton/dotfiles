
# Frigging El Capitan /etc/zprofile
if [[ "${PATH:0:28}" == "/usr/local/bin:/usr/bin:/bin" ]] ; then
  [[ -f ~/.shell-path ]] && source ~/.shell-path
fi


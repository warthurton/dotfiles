
### I really do not like symlinking my dotfiles. I have two repos, one for public files, which I use like this:

    alias pubgit='git --git-dir="$HOME/.git-pub-dotfiles" --work-tree="$HOME"'

### and one for private/secure stuff, which is almost the same:

    alias prvgit='git --git-dir="$HOME/.git-prv-dotfiles" --work-tree="$HOME"'

### I also have a simple ~/.gitignore:

    *
    **/.DS_Store

### then, when I make changes, I use git more or less normally.  To update or bootstrap a new machine, I use this function from .shell-common:

    confsync() {
      cd $HOME
      for host in $* ; do
        (pubgit ls-files; prvgit ls-files) | rsync -vaxR --files-from=- . ${host//":"/}:
      done
    }


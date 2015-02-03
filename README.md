## Simple-ish

After trying many different ways of managing dotfiles and deployment, I've decided that I dislike everything.  In general, I can't stand:

1. All of the shell starting point plus plugins projects.
1. All of the fancy prompt projects.
1. All of the dotfile manager projects.
1. Trusting anything else to setup my $PATH.
1. Bootstrapping my dotfiles on a new machine with anything more complicated than rsync.
1. Whiney sounding lists.

## Git, ssh, rsync

I have two repos, one for public files, and one for private/secure stuff.  I use them with these aliases:

    alias pubgit='git --git-dir="$HOME/.git-pub-dotfiles" --work-tree="$HOME"'
    alias prvgit='git --git-dir="$HOME/.git-prv-dotfiles" --work-tree="$HOME"'

and this ~/.gitignore:

    *
    **/.DS_Store

To make your own pubgit and prvgit, you could:

    pubgit init
    prvgit init

The caveat of the git-ignore settings is that to add something, let's say your .bashrc, you'll have to `pubgit add -f .bashrc` to force the file to be added.
To update or bootstrap a new machine, I use this function from .shell-common:

    confsync() {
      cd $HOME
      for host in $* ; do
        (pubgit ls-files; prvgit ls-files) | rsync -vaxR --files-from=- . ${host//":"/}:
      done
    }
 
I would love to add more dead-simple prompt info, for python virtualenvs and such.  I don't currently write enough python to need it right now, but that's what pull requests are for.


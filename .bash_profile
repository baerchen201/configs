#
# ~/.bash_profile
#

# == LOCAL BIN OVERRIDES ==
if [ -d ~/.local/bin ]; then
  export PATH="$(realpath ~/.local/bin):$PATH"
fi

export TERM="linux"

[[ -f ~/.tty_autolaunch ]] && . ~/.tty_autolaunch

# == FALLBACK ==
# just loads bashrc, this is run when
#  > on a tty without a specific dedicated application (see above)
#  > not in a tty (terminal emulator, tmux, ssh, etc.)
[[ -f ~/.bashrc ]] && . ~/.bashrc

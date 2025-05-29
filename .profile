#
# .profile
#

export PATH="$HOME/.local/bin:$PATH"

export EDITOR=nvim
export PAGER=less
export MANPAGER="nvim +Man!"
export GTK_THEME="Adwaita:dark"

# set ENV to a file invoked each time sh is started for interactive use.
ENV=$HOME/.shrc; export ENV

# Let sh(1) know it's at home, despite /home being a symlink.
[ "$PWD" != "$HOME" ] && [ "$PWD" -ef "$HOME" ] && cd

[ -x /usr/bin/resizewin ] && /usr/bin/resizewin -z
[ -x /usr/bin/fortune ] && /usr/bin/fortune freebsd-tips && echo ""

alias vi=nvim
alias vim=vi
alias ls="ls --color=always"
alias doas=sudo

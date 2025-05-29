if [[ "$(tty)" == "/dev/ttyv0" ]]; then startx ; fi

source /usr/local/share/bash-completion/bash_completion.sh

source /usr/local/share/git-core/contrib/completion/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1 \
	GIT_PS1_SHOWSTASHSTATE=1 \
	GIT_PS1_SHOWUNTRACKEDFILES=1 \
	GIT_PS1_SHOWCONFLICTSTATE=1 \
	GIT_PS1_SHOWCOLORHINTS=1 \
	GIT_PS1_SHOWUPSTREAM=auto \
	GIT_PS1_DESCRIBE_STYLE=branch
export PS1='\[\e[38;5;244m\](\[\e[0m\]\[\e[34m\]\w\[\e[0m\]\[\e[38;5;244m\])\[\e[0m\] '\
"\$(__git_ps1 '\[\e[38;5;244m\][\[\e[0m\]%s\[\e[38;5;244m\]]\[\e[0m\] ')"\
'\[\e[38;5;244m\]|>\[\e[0m\] '

eval "$(fzf --bash)"
eval "$(zoxide init --cmd cd bash)"

launch() { nohup $1 >/dev/null 2>&1 & }

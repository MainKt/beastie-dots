if [[ "$(tty)" == "/dev/ttyv0" ]]; then startx ; fi

test -f "$HOME/.profile" && . "$HOME/.profile"

export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:erasedups

source /usr/local/share/bash-completion/bash_completion.sh

source /usr/local/share/git-core/contrib/completion/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1 \
	GIT_PS1_SHOWSTASHSTATE=1 \
	GIT_PS1_SHOWUNTRACKEDFILES=1 \
	GIT_PS1_SHOWCONFLICTSTATE=1 \
	GIT_PS1_SHOWCOLORHINTS=1 \
	GIT_PS1_SHOWUPSTREAM=auto \
	GIT_PS1_DESCRIBE_STYLE=branch

set_prompt() {
    local status="$?"
    local exit_status=""
    local ssh_prefix=""

    local gray="\[$(tput setaf 244)\]"
    local red="\[$(tput setaf 1)\]"
    local blue="\[$(tput setaf 4)\]"
    local reset="\[$(tput sgr0)\]"
    local green="\[$(tput setaf 2)\]"

    [[ $status != 0 ]] &&
	exit_status="${gray}{${red}${status}${reset}${gray}}${reset} "

    [[ -n "$SSH_CONNECTION" ]] &&
	ssh_prefix="${green}\h${gray}:${reset}"

    PS1="${exit_status}"
    PS1+="${gray}(${reset}${ssh_prefix}${blue}\w${reset}${gray})${reset} "
    PS1+="$(__git_ps1 "${gray}[${reset}%s${gray}]${reset} ")"

    if [[ $(whoami) == "root" ]]; then
	PS1+="${gray}#>${reset} "
    else
	PS1+="${gray}|>${reset} "
    fi
}
export PROMPT_COMMAND=set_prompt

eval "$(fzf --bash)"

source $HOME/.local/share/bash/completion.bash
bind -x '"\C-x\C-o": fzf_bash_completion'

open() { nohup $@ >/dev/null 2>&1 & }

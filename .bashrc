#!/usr/bin/env bash
#
# Author: Sam leenderts
# Date: 2024


if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Created by `pipx` on 2024-07-20 07:12:59
export PATH="$PATH:/home/samm/.local/bin"

# Set environment
export EDITOR='code'
export GREP_COLOR='1;36'
export HISTCONTROL='ignoredups'
export HISTSIZE=5000
export HISTFILESIZE=5000
export TZ='Australia/Brisbane'

# Aliases
alias ..='echo "cd .."; cd ..'
alias chomd='chmod'
alias externalip='curl -sS http://www.ipconfig.sh/'
alias gerp='grep'
alias suod='sudo'
alias scanhome="echo 'sudo clamdscan --fdpass --log=/var/log/clamav/clamdscan.log /home'"

# Git Aliases
alias nb='git checkout -b "$USER-$(date +%s)"' # new branch
alias ga='git add . --all'
alias gb='git branch'
alias gc='git clone'
alias gci='git commit -a'
alias gco='git checkout'
alias gd="git diff ':!*lock'"
alias gdf='git diff' # git diff (full)
alias gi='git init'
alias gl='git log'
alias gp='git push origin HEAD'
alias gr='git rev-parse --show-toplevel' # git root
alias gs='git status'
alias gt='git tag'
alias gu='git pull' # gu = git update

gho() {
	local file=$1
	local remote=${2:-origin}

	# get the git root dir, branch, and remote URL
	local gr=$(git rev-parse --show-toplevel)
	local branch=$(git rev-parse --abbrev-ref HEAD)
	local url=$(git config --get "remote.$remote.url")

	[[ -n $gr && -n $branch && -n $remote ]] || return 1

	# construct the path
	local path=${PWD/#$gr/}
	[[ -n $file ]] && path+=/$file

	# extract the username and repo name
	local a
	IFS=:/ read -a a <<< "$url"
	local len=${#a[@]}
	local user=${a[len-2]}
	local repo=${a[len-1]%.git}

	local url="https://github.com/$user/$repo/tree/$branch$path"
	echo "$url"
	open "$url"
}

gmb() { # git main branch
	local main
	main=$(git symbolic-ref --short refs/remotes/origin/HEAD)
	main=${main#origin/}
	[[ -n $main ]] || return 1
	echo "$main"
}

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias kc='kubectl'

gho() {
	local file=$1
	local remote=${2:-origin}

	# get the git root dir, branch, and remote URL
	local gr=$(git rev-parse --show-toplevel)
	local branch=$(git rev-parse --abbrev-ref HEAD)
	local url=$(git config --get "remote.$remote.url")

	[[ -n $gr && -n $branch && -n $remote ]] || return 1

	# construct the path
	local path=${PWD/#$gr/}
	[[ -n $file ]] && path+=/$file

	# extract the username and repo name
	local a
	IFS=:/ read -a a <<< "$url"
	local len=${#a[@]}
	local user=${a[len-2]}
	local repo=${a[len-1]%.git}

	local url="https://github.com/$user/$repo/tree/$branch$path"
	echo "$url"
	open "$url"
}

gmb() { # git main branch
	local main
	main=$(git symbolic-ref --short refs/remotes/origin/HEAD)
	main=${main#origin/}
	[[ -n $main ]] || return 1
	echo "$main"
}

epoch() {
	local num=${1//[^0-9]/}
	(( ${#num} < 13 )) && num=${num}000
	node -pe "new Date(+process.argv[1]);" "$num"
}

export PROMPT_COMMAND='PS1_CMD1=$(__git_ps1 " (%s)")'; PS1='\[\e[38;5;37m\]\u\[\e[38;5;36m\]@\[\e[38;5;37m\]\h\[\e[0m\] | \[\e[38;5;117m\]\w\[\e[38;5;117m\]/\[\e[38;5;169m\]${PS1_CMD1}\[\e[0m\]\\$ '
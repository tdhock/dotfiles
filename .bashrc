# Print a star if there are uncommitted changes.
function star_if_dirty {
  [[ $(LC_ALL=C git status 2> /dev/null | tail -n1 | awk '{print $1}') != "nothing" ]] && echo "*"
}
# Prepend current git branch in terminal.
function parse_git_branch {
    branch=$(git branch --show-current 2> /dev/null)
    if [ "$branch" != "" ]; then
	echo "[$branch$(star_if_dirty)]"
    fi
}
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[0;33m\]$(parse_git_branch)\[\033[0;m\]\$ '

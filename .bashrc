# Prepend current git branch in terminal
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1 | awk '{print $1}') !=
"nothing" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/*
\(.*\)/(\1$(parse_git_dirty))/"
}
export PS1='\u@\h:\w\[\033[0;33m\]$(parse_git_branch)\[\033[0;m\]$ '
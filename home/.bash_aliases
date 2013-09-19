alias h='history | less +G'

# Aptitude aliases
alias update='time sudo apt-get update'
alias upgrade='time sudo apt-get upgrade'
alias dupgrade='time sudo apt-get dist-upgrade'

# Git aliases
alias gitk='gitk --all'

# Vim aliases
#alias gvim='gvim -p'
#alias vim='gvim -p'
#alias vi='vim -p'
function sudo () { [[ $1 == vim || $1 == vi ]] && shift && sudoedit "$@" || command sudo "$@"; }

# Python aliases
alias pep8='pep8 --ignore=E111 --repeat'
alias flake8all="find . -name '*.py' -exec flake8 {} +"
alias cleanpyc="echo find . -name '*.pyc' -delete; find . -name '*.pyc' -delete"

# Program aliases
alias ltspice='"/home/$(whoami)/.wine/drive_c/Program Files (x86)/LTC/LTspiceIV/scad3.exe" &'
alias matlab='matlab -glnx86 -desktop &'

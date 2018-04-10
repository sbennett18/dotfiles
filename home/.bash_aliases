# .bash_aliases

# User specific aliases and functions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
#
# Interactive operation...
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
#
# Default to human readable figures
# alias df='df -h'
# alias du='du -h'
#
# Misc :)
# alias less='less -r'                          # raw control characters
alias whence='type -a'                        # where, of a sort
alias grep='grep --color -n'                  # show differences in colour
alias egrep='egrep --color=auto -n'           # show differences in colour
alias fgrep='fgrep --color=auto -n'           # show differences in colour
alias cgrep='grep --include=*.{c*,h*} -n'

# Some shortcuts for different directory listings
alias sl='ls'
alias ls='ls -F --color=tty'                  # classify files in colour
alias l='ls -CF'                              #
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..
alias lal='ls -Al'                            # long list, all but . and ..
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'

alias h='history | less +G'

alias vimrc="vim ${HOME}/.vimrc"

alias svn-reset-hard='svn revert . -R && svn status | rm -rf $(awk -f <(echo "/^?/{print \$2}") <(svn status) ;)'

alias ctagger='ctags --extra=+f --tag-relative=yes --totals=yes --recurse -f tags .'

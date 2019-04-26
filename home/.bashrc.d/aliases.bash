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

alias su='su --login'

alias cdp='command cd -P'

# Misc :)
# alias less='less -r'                          # raw control characters
alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in colour
alias egrep='egrep --color=auto -n'           # show differences in colour
alias fgrep='fgrep --color=auto -n'           # show differences in colour
alias cgrep='grep --include=*.{c*,h*} -n'


# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    # alias dir='dir --color=auto'
    # alias vdir='vdir --color=auto'
fi
# Some shortcuts for different directory listings
alias sl='ls'
alias ls='ls -F --color=tty'                  # classify files in colour
alias l='ls -CF'                              #
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..
alias lal='ls -Al'                            # long list, all but . and ..
alias lh='ls -d .??*'                         # list hidden
alias lhl='ls -ld .??*'                       # long list hidden
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'

alias h='history | less +G'

alias vi='vim'
alias vimrc='vim ~/.vimrc'

alias vimbashrc='vim ~/.bashrc'

alias svn-reset-hard='svn revert . -R && svn status | rm -rf $(awk -f <(echo "/^?/{print \$2}") <(svn status) ;)'
alias svn-remove-untracked='\rm -i $( \svn status | \grep ^? | \awk "{ print \$2 }" )'

alias cleanpyc="echo find . -name '*.pyc' -delete; find . -name '*.pyc' -delete"

alias ctagger='ctags --extra=+f --tag-relative=yes --totals=yes --recurse -f tags .'

alias systemctl='sudo systemctl'
alias pacman='sudo pacman'
alias pacrepo='sudo reflector -l 20 -f 10 --save /etc/pacman.d/mirrorlist'
alias journalctl='sudo journalctl'
alias pacu='sudo pacman -Syu --noconfirm'
alias se='ls /usr/bin | grep'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

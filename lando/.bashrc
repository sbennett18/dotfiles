# .bashrc

# Source global definitions
if [ -r /etc/bashrc ]; then
    . /etc/bashrc
fi

# function join_by { local IFS="$1"; shift; echo "$*"; }

declare -A COLORS=(
            ['bold']=1        ['light']=2          ['blink']=5          ['invert']=7
           ['black']=30         ['red']=31         ['green']=32         ['yellow']=33         ['blue']=34         ['purple']=35         ['cyan']=36         ['white']=37
           ['Black']=40         ['Red']=41         ['Green']=42         ['Yellow']=43         ['Blue']=44         ['Purple']=45         ['Cyan']=46         ['White']=47
    ['bright-black']=90  ['bright-red']=91  ['bright-green']=92  ['bright-yellow']=93  ['bright-blue']=94  ['bright-purple']=95  ['bright-cyan']=96  ['bright-white']=97
    ['Bright-Black']=100 ['Bright-Red']=101 ['Bright-Green']=102 ['Bright-Yellow']=103 ['Bright-Blue']=104 ['Bright-Purple']=105 ['Bright-Cyan']=106 ['Bright-White']=107
)

__PROMPT_BG=${COLORS['Bright-Black']}

+ ()
{
    t=''
    for arg in $@; do
        if [ ${COLORS[${arg}]+isset} ]; then
            t="${t};${COLORS[${arg}]}"
        else
            echo "Bad color: ${arg}"
            continue
        fi
    done
    __PROMPT_BG="${t}"
    printf "\033[${t}m"
}

++ ()
{
    #printf %s $@
    t="${__PROMPT_BG}"
    for arg in $@; do
        if [ ${COLORS[${arg}]+isset} ]; then
            t="${t};${COLORS[${arg}]}"
        else
            echo "Bad color: ${arg}"
            continue
        fi
    done
    printf "\033[${t}m"
}

-- ()
{
    printf "\033[m\\e[${__PROMPT_BG}m"
}

prompt_command ()
{
    RET=$?
    ERRMSG=""
    if [ ${RET} -ne 0 ]; then
        ERRMSG="$(+ red)\$$(+)";
    else
        ERRMSG="\$"
    fi
    # Pass the read $? along so it can be read on the command line
    return ${RET}
}

PROMPT_COMMAND=prompt_command

source ~/.git-prompt.sh
#PS1="$(+ Bright-Black)\\u@\\h $(++ bold yellow)\\W$(--)\$(__git_ps1 ' ($(++ bold green)%s$(--))')$(+ bright-black)$(+)\${ERRMSG} "
PS1="$(++)\\u@\\h $(++ bold yellow)\\W$(++ bold green)\$(__git_ps1 ' (%s)')$(+ bright-black)$(+)\${ERRMSG} "
#PS1='[\u@\h \W$(__git_ps1 " ($(+ bold green)%s$(+))")]${ERRMSG}\$ '

export DISPLAY=localhost:0.0

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
export EDITOR=vim
export LESS=' -i -r '

# Aliases
#
# Some people use a different file for aliases
if [ -r ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Functions
#
# Some people use a different file for functions
if [ -r ~/.bash_functions ]; then
    . ~/.bash_functions
fi

alias sl='ls'
alias h='history | less +G'
alias visp='vim -O'
alias svn-reset-hard='svn revert . -R && svn status | rm -rf $(awk -f <(echo "/^?/{print \$2") <(svn status) ;)'
alias la='ls -A'

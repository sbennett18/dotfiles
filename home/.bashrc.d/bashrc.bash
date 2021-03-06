# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# function join_by { local IFS="$1"; shift; echo "$*"; }

declare -A COLORS=(
            ['bold']=1        ['light']=2          ['blink']=5          ['invert']=7
           ['black']=30         ['red']=31         ['green']=32         ['yellow']=33         ['blue']=34         ['purple']=35         ['cyan']=36         ['white']=37
           ['Black']=40         ['Red']=41         ['Green']=42         ['Yellow']=43         ['Blue']=44         ['Purple']=45         ['Cyan']=46         ['White']=47
    ['bright-black']=90  ['bright-red']=91  ['bright-green']=92  ['bright-yellow']=93  ['bright-blue']=94  ['bright-purple']=95  ['bright-cyan']=96  ['bright-white']=97
    ['Bright-Black']=100 ['Bright-Red']=101 ['Bright-Green']=102 ['Bright-Yellow']=103 ['Bright-Blue']=104 ['Bright-Purple']=105 ['Bright-Cyan']=106 ['Bright-White']=107
)

# Non-printing sequences should be enclosed in \[ and \]
# https://www.gnu.org/software/bash/manual/bashref.html#Controlling-the-Prompt
+ ()
{
    local cv
    if [ $# -eq 0 ]; then
        cv='0;0'
    else
        for arg in $@; do
            if [ ${COLORS[${arg}]+isset} ]; then
                cv+=";${COLORS[${arg}]}"
            else
                echo "Bad color: ${arg}"
                continue
            fi
        done
    fi
    printf "\[\033[${cv}m\]"
}

__prompt_ret_cmd ()
{
    local -ri RET=$?
    if [ ${RET} -ne 0 ]; then
        local -r ERRMSG="$(+ red) ${RET}\$$(+)";
    else
        local -r ERRMSG="\$"
    fi
    if [ -n "${VIRTUAL_ENV}" ]; then
        local -r VENV="($( basename "${VIRTUAL_ENV}" )) "
    else
        local -r VENV=""
    fi

    __git_ps1 "[$(+ bold green)\\u@\\h$(+)] ${VENV}$(+ bold blue)\\w$(+)" "$(+)${ERRMSG} "

    # Pass the read $? along so it can be read on the command line
    return ${RET}
}

if [ "$color_prompt" = yes ]; then
    # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWUPSTREAM="auto"
    GIT_PS1_SHOWCOLORHINTS=1
    PROMPT_COMMAND=__prompt_ret_cmd
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *)
        ;;
esac

# colored GCC warnings and errors
# export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# colored man pages :)
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;34m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# syntax highlighting in less
export LESSOPEN="| src-hilite-lesspipe.sh %s"
export LESS=' -i -R '

export EDITOR=vim

# User specific environment and startup programs
export PYENV_ROOT="${HOME}/.pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"

if command -v pyenv 1> /dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

export QT_STYLE_OVERRIDE=gtk
export QT_SELECT=qt5

if [[ $LANG = '' ]]; then
    export LANG=en_US.UTF-8
fi

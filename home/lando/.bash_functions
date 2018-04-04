git()
{
    if [ x"$1" = xvdiff ] || [ x"$1" = xvdi ]; then
        shift
        $(which git) --no-pager diff "$@" | vim -R -
    else
        $(which git) "$@"
    fi
}

svn()
{
    if [ x"$1" = xvdiff ] || [ x"$1" = xvdi ]; then
        shift
        $(which svn) diff "$@" | vim -R -
    else
        $(which svn) "$@"
    fi
}

auto-retry()
{
    false
    while [ $? -ne 0 ]; do
        echo "Attempting ($(date))..."
        "$@" || (sleep 3; false)
    done
}

helpless ()
{
    "$1" --help | less
}

corez ()
{
    local host="$1"; shift
    local ssh_cmd="sshpass -p b10root ssh -o StrictHostKeyChecking=no root@${host}-corez -T"
    local opts='display system.log shortlist'

    if [ $# -eq 0 ]; then
        sshpass -p b10root ssh -o StrictHostKeyChecking=no root@${host}-corez
    elif [ $# -eq 1 ]; then
        case "$1" in
        'display')
            echo 'cd /run/media/mmcblk0p2/cm_scripts && ./display.sh' | ${ssh_cmd}
            ;;
        'system.log')
            echo 'tail -f /run/media/mmcblk0p3/logs/system.log' | ${ssh_cmd}
            ;;
        'shortlist')
            echo "Available commands: ${opts}"
            ;;
        *)
            echo "$@" | ${ssh_cmd}
            ;;
        esac
    else
        echo "$@" | ${ssh_cmd}
    fi
}
# complete -F _known_hosts corez

_corez ()
{
    local cur prev words cword
    _init_completion -n : || return

    _known_hosts_real -- "${cur}"
    local cur prev opts hosts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(corez 'dummy' 'shortlist')
    hosts=$(getent hosts | grep corez | tr -s '[:blank:]-' '\t' | cut -f 2 | sort | tr -s '[:space:]' ' ')

    if [[ "${prev}" == "corez" ]]; then
        COMPREPLY=( $(compgen -W "${hosts}" -- ${cur}) )
    else
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    fi
}
complete -F _corez corez

# Some example functions:
#
# a) function settitle
# settitle ()
# {
#   echo -ne "\e]2;$@\a\e]1;$@\a";
# }
#
# b) function cd_func
# This function defines a 'cd' replacement function capable of keeping,
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
cd_func ()
{
  local x2 the_new_dir adir index
  local -i cnt

  if [[ $1 ==  "--" ]]; then
    dirs -v
    return 0
  fi

  the_new_dir=$1
  [[ -z $1 ]] && the_new_dir=$HOME

  if [[ ${the_new_dir:0:1} == '-' ]]; then
    #
    # Extract dir N from dirs
    index=${the_new_dir:1}
    [[ -z $index ]] && index=1
    adir=$(dirs +$index)
    [[ -z $adir ]] && return 1
    the_new_dir=$adir
  fi

  #
  # '~' has to be substituted by ${HOME}
  [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"

  #
  # Now change to the new dir and add to the top of the stack
  pushd "${the_new_dir}" > /dev/null
  [[ $? -ne 0 ]] && return 1
  the_new_dir=$(pwd)

  #
  # Trim down everything beyond 11th entry
  popd -n +11 2>/dev/null 1>/dev/null

  #
  # Remove any other occurence of this dir, skipping the top of the stack
  for ((cnt=1; cnt <= 10; cnt++)); do
    x2=$(dirs +${cnt} 2>/dev/null)
    [[ $? -ne 0 ]] && return 0
    [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
    if [[ "${x2}" == "${the_new_dir}" ]]; then
      popd -n +$cnt 2>/dev/null 1>/dev/null
      cnt=cnt-1
    fi
  done

  return 0
}

alias cd=cd_func

# vim: filetype=sh

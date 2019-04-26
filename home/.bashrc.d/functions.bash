# .bash_functions

whichfunc ()
(
    shopt -s extdebug
    declare -F "$1"
)

git ()
{
    local -r GIT="$( which git )"
    case "${1}" in
        vdiff|vdi)
            shift
            "${GIT}" --no-pager diff "$@" | vim -R -
            ;;
        *)
            "${GIT}" "$@"
            ;;
    esac
}


svn ()
{
    local -r SVN="$( which svn )"
    case "${1}" in
        diffstat|dis)
            shift
            "${SVN}" diff "$@" | diffstat -cC
            ;;
        diff|di)
            shift
            "${SVN}" diff -x -p "$@"
            ;;
        incoming|inc)
            shift
            local -r OLD=$( [ $# -eq 0 ] && echo "." || echo "$1" )
            readarray -t < <( svn info "${OLD}" )
            local -r URL="${MAPFILE[2]#URL: }"
            local -r REPO_ROOT="${MAPFILE[3]#Repository Root: }"
            svn diff --old "${OLD}" --new "^${URL#$REPO_ROOT}"
            ;;
        outgoing|out)
            shift
            local -r NEW=$( [ $# -eq 0 ] && echo "." || echo "$1" )
            readarray -t < <( svn info "${NEW}" )
            local -r URL="${MAPFILE[2]#URL: }"
            local -r REPO_ROOT="${MAPFILE[3]#Repository Root: }"
            svn diff --new "${NEW}" --old "^${URL#$REPO_ROOT}"
            ;;
        vdiff|vdi)
            shift
            svn diff "$@" | vim -R -
            ;;
        vincoming|vinc)
            shift
            svn incoming "$@" | vim -R -
            ;;
        voutgoing|vout)
            shift
            svn outgoing "$@" | vim -R -
            ;;
        *)
            "${SVN}" "$@"
            ;;
    esac
}


cleanvimdir ()
{
    pushd ~/.vim > /dev/null
    rm -rIv undo/ view/ backup/
    popd > /dev/null
}


autoretry ()
{
    false
    while [ $? -ne 0 ]; do
        echo "Attempting ($(date))..."
        "$@" || ( sleep 3; false )
    done
}


helpless ()
{
    "$1" --help | less
}


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

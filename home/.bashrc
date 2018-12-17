# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

[ -f /etc/bashrc ] && . /etc/bashrc

if [ -d ~/.bashrc.d ]; then
    for f in ~/.bashrc.d/*; do
        [ -f "${f}" ] && . "${f}"
    done
    unset f
fi


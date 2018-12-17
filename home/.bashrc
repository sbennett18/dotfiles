# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

if [ -d ~/.bashrc.d ]; then
    for f in ~/.bashrc.d/*; do
        [ -r "${f}" ] && . "${f}"
    done
    unset f
fi


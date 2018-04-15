# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

if [ -d ~/.bashrc.d ]; then
    for i in ~/.bashrc.d/*; do
        if [ -r $i ]; then
            . $i
        fi
    done
    unset i
fi


if [ -d ~/.bashrc.d ]; then
    for i in ~/.bashrc.d/*; do
        if [ -r $i ]; then
            . $i
        fi
    done
    unset i
fi


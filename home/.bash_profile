## To get 256-color terminal (for solarized)
#if [ "$TERM" = "xterm" ] ; then
    #if [ -z "$COLORTERM" ] ; then
        #if [ -z "$XTERM_VERSION" ] ; then
            #echo "Warning: Terminal wrongly calling itself 'xterm'."
        #else
            #case "$XTERM_VERSION" in
                #"XTerm(256)") TERM="xterm-256color" ;;
                #"XTerm(88)") TERM="xterm-88color" ;;
                #"XTerm") ;;
                #*)
                    #echo "Warning: Unrecognized XTERM_VERSION: $XTERM_VERSION"
                    #;;
            #esac
        #fi
    #else
        #case "$COLORTERM" in
            #gnome-terminal)
                ## Those crafty Gnome folks require you to check COLORTERM,
                ## but don't allow you to just *favor the setting over TERM.
                ## Instead you need to compare it and perform some guesses
                ## based upon the value. This is, perhaps, too simplistic.
                #TERM="gnome-256color"
                #;;
            #*)
                #echo "Warning: Unrecognized COLORTERM: $COLORTERM"
                #;;
        #esac
    #fi
#fi

if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm'
fi

export LS_OPTIONS="$LS_OPTIONS --color=tty"

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
#export PYTHONPATH="/usr/local/lib/python2.6/site-packages:$PYTHONPATH"
#export PYTHONPATH=$PYTHONPATH:/home/`whoami`/python

#export STUDIO_JDK=/usr/lib/jvm/jdk1.7.0_25

if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

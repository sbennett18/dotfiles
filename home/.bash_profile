if [ -e /usr/share/terminfo/x/xterm-256color ]; then
   export TERM='xterm-256color'
else
   export TERM='xterm-color'
fi

export LS_OPTIONS="$LS_OPTIONS --color=tty"

#export PYTHONPATH="/usr/local/lib/python2.6/site-packages:$PYTHONPATH"
#export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
#export PYTHONPATH=$PYTHONPATH:/home/`whoami`/python

if [ -f ~/.bash_aliases ]; then
  . ~/.bashrc
fi

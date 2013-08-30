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

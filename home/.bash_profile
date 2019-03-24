# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
export PATH=${PATH}:${HOME}/.local/bin:${HOME}/bin
#export LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}
#export PYTHONPATH="/usr/local/lib/python2.6/site-packages:${PYTHONPATH}"
export PYTHONPATH=${PYTHONPATH}:${HOME}/python

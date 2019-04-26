# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# Set PATH so it includes user's private bin if it exists
# if [ -d "${HOME}/bin" ] ; then
#   PATH="${HOME}/bin:${PATH}"
# fi

# Set MANPATH so it includes users' private man if it exists
# if [ -d "${HOME}/man" ]; then
#   MANPATH="${HOME}/man:${MANPATH}"
# fi

# Set INFOPATH so it includes users' private info if it exists
# if [ -d "${HOME}/info" ]; then
#   INFOPATH="${HOME}/info:${INFOPATH}"
# fi

# User specific environment and startup programs
export PATH=${PATH}:${HOME}/.local/bin:${HOME}/bin
#export LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}
#export PYTHONPATH="/usr/local/lib/python2.6/site-packages:${PYTHONPATH}"
export PYTHONPATH=${PYTHONPATH}:${HOME}/python

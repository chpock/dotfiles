
BASHRC_HOME="/c/DriveD/Projects/dotfiles/tools"
[ -d "$BASHRC_HOME" ] || BASHRC_HOME="/w/projects/dotfiles/tools"

if [ -d "$BASHRC_HOME" ]; then
    alias bashrc="$BASHRC_HOME/bashrc"
    type -t __bashrc_completion >/dev/null 2>&1 || source <("$BASHRC_HOME/bashrc" -generate bash-completion)
fi

unset BASHRC_HOME


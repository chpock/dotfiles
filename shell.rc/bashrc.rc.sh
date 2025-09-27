
# higher priority for WSL repo location
BASHRC_HOME="/w/projects/dotfiles/tools"
[ -d "$BASHRC_HOME" ] || BASHRC_HOME="/c/DriveD/Projects/dotfiles/tools"

if [ -d "$BASHRC_HOME" ]; then
    # Disable: This expands when defined, not when used. Consider escaping. [SC2139]
    # shellcheck disable=SC2139
    alias bashrc="$BASHRC_HOME/bashrc"
    # shellcheck source=/dev/null
    type -t __bashrc_completion >/dev/null 2>&1 || source <("$BASHRC_HOME/bashrc" -generate bash-completion)
fi

unset BASHRC_HOME


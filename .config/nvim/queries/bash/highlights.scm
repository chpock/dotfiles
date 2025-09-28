; extends

; Don't mark variables in uppercase as constants. Override this rule:
; https://github.com/nvim-treesitter/nvim-treesitter/blob/42fc28ba918343ebfd5565147a42a26580579482/queries/bash/highlights.scm#L228
((variable_name) @variable
  (#lua-match? @variable "^[A-Z][A-Z_0-9]*$"))

; We have to duplicate rule for builtin bash variables as the above rule will override
; this rule from original highlight file:
; https://github.com/nvim-treesitter/nvim-treesitter/blob/42fc28ba918343ebfd5565147a42a26580579482/queries/bash/highlights.scm#L231
((variable_name) @variable.builtin
  (#any-of? @variable.builtin
    ; https://www.gnu.org/software/bash/manual/html_node/Bourne-Shell-Variables.html
    "CDPATH" "HOME" "IFS" "MAIL" "MAILPATH" "OPTARG" "OPTIND" "PATH" "PS1" "PS2"
    ; https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html
    "_" "BASH" "BASHOPTS" "BASHPID" "BASH_ALIASES" "BASH_ARGC" "BASH_ARGV" "BASH_ARGV0" "BASH_CMDS"
    "BASH_COMMAND" "BASH_COMPAT" "BASH_ENV" "BASH_EXECUTION_STRING" "BASH_LINENO"
    "BASH_LOADABLES_PATH" "BASH_REMATCH" "BASH_SOURCE" "BASH_SUBSHELL" "BASH_VERSINFO"
    "BASH_VERSION" "BASH_XTRACEFD" "CHILD_MAX" "COLUMNS" "COMP_CWORD" "COMP_LINE" "COMP_POINT"
    "COMP_TYPE" "COMP_KEY" "COMP_WORDBREAKS" "COMP_WORDS" "COMPREPLY" "COPROC" "DIRSTACK" "EMACS"
    "ENV" "EPOCHREALTIME" "EPOCHSECONDS" "EUID" "EXECIGNORE" "FCEDIT" "FIGNORE" "FUNCNAME"
    "FUNCNEST" "GLOBIGNORE" "GROUPS" "histchars" "HISTCMD" "HISTCONTROL" "HISTFILE" "HISTFILESIZE"
    "HISTIGNORE" "HISTSIZE" "HISTTIMEFORMAT" "HOSTFILE" "HOSTNAME" "HOSTTYPE" "IGNOREEOF" "INPUTRC"
    "INSIDE_EMACS" "LANG" "LC_ALL" "LC_COLLATE" "LC_CTYPE" "LC_MESSAGES" "LC_NUMERIC" "LC_TIME"
    "LINENO" "LINES" "MACHTYPE" "MAILCHECK" "MAPFILE" "OLDPWD" "OPTERR" "OSTYPE" "PIPESTATUS"
    "POSIXLY_CORRECT" "PPID" "PROMPT_COMMAND" "PROMPT_DIRTRIM" "PS0" "PS3" "PS4" "PWD" "RANDOM"
    "READLINE_ARGUMENT" "READLINE_LINE" "READLINE_MARK" "READLINE_POINT" "REPLY" "SECONDS" "SHELL"
    "SHELLOPTS" "SHLVL" "SRANDOM" "TIMEFORMAT" "TMOUT" "TMPDIR" "UID"))


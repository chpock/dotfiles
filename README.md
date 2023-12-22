# How to use

## Linux
1. Install the statup script:
```shell
$ curl -s -o ~/.bashrc https://raw.githubusercontent.com/chpock/dotfiles/master/bashrc
```
2. Edit variables as described in the [Variables](#Variables) section.
3. Re-login to your shell.

## Windows
This script can be used only with [kitty](http://www.9bis.net/kitty). This is port of [putty](https://www.putty.org/) but with some additional features. A critical additional feature is the ability to run some script during remote login.
1. Download the [startup script](https://raw.githubusercontent.com/chpock/dotfiles/master/bashrc) and place it to some directory.
2. Edit variables as described in the [Variables](#Variables) section.
3. Connect to remote machine using the command:
```
putty <remote user>@<remote machine> -m "C:\<path to>\bashrc" -t
```
## Variables
You **MUST** replace 4 variables according to your indentify: "IAM", "SSH_PUB_KEY", "GIT_USER_NAME" and "GIT_USER_EMAIL". They are located at the top of the script.
* **IAM**: the string that represents your personal identification on machine(s). For example, your initials.
* **SSH_PUB_KEY**: your public ssh key that will be automatically installed on all machines.
* **GIT_USER_NAME**: git user name. Used only in the `git-config` function.
* **GIT_USER_EMAIL**: git user email. Used only in the `git-config` function.

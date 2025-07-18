# If not running interactively, don't do anything.
case $- in
  *i*) ;;
    *) return;;
esac

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
# For setting history length see HISTSIZE and HISTFILESIZE.
HISTSIZE=1000
HISTFILESIZE=2000

# Append to the history file, don't overwrite it.
shopt -s histappend
# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Make less more friendly for non-text input files.
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set variable identifying the chroot you work in (used in the prompt below).
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# Set a fancy prompt (non-color, unless we know we "want" color).
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

# Uncomment for a colored prompt.
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		color_prompt=yes
  else
	  color_prompt=
  fi
fi

# Prompt with user information, directory, branch, among other information.
if [ "$color_prompt" = yes ]; then
  git_branch(){
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
  }
  if [ -z "$PROMPT_TIME" ]; then
    PROMPT_TIME=$(date +\%H:\%M:\%S)
  fi
  PROMPT_COMMAND='PROMPT_TIME=$(date +\%H:\%M:\%S)'

  if [ "$(id -u)" -eq 0 ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[0;33m\]$(git_branch) \[\033[35m\]$(ruby_version_prompt)\[\033[00m\]\n$PROMPT_TIME \$ '
  else
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[0;33m\]$(git_branch) \[\033[35m\]$(ruby_version_prompt)\[\033[00m\]\n$PROMPT_TIME \$ '
  fi
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(git_branch) \[\033[38;5;129m\]\n$PROMPT_TIME\[\033[00m\] \$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to "user@host:dir".
case "$TERM" in
xterm*|rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*)
  ;;
esac

# Enable color support of ls and also add handy aliases.
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Colored GCC warnings and errors.
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ---
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - bash)"
# Function to display the active Ruby version (via rbenv).
ruby_version_prompt() {
  if command -v rbenv >/dev/null 2>&1; then
    local version=$(rbenv version-name 2>/dev/null)
    if [ -n "$version" ]; then
      echo -n "ruby-$version"
    fi
  fi
}

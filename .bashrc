# Verifica se o shell está em modo interativo.
case $- in
  *i*) ;;
    *) return;;
esac
# Comportamento do histórico.
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
# Opções do shell.
# "histappend": histórico ser "adicionado" ao invés de sobrescrito;
# "checkwinsize": auto atualiza as variáveis de terminal ao redimensionar a janela;
# "globstar": ativa a expansão de globos recursivos;
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar
# Configura o "lesspipe" se disponível.
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
# Configura o chroot para Debian (se disponível).
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi
# Prompt colorido se o terminal for compatível.
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac
# Força o prompt colorido.
force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	  color_prompt=yes
  else
	  color_prompt=yes
  fi
fi
# Prompt com informações de usuário, diretório, branch, entre outras infos.
if [ "$color_prompt" = yes ]; then
  git_branch(){
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
  }
  if [ -z "$PROMPT_TIME" ]; then
    PROMPT_TIME=$(date +\%H:\%M:\%S)
  fi
  PROMPT_COMMAND='PROMPT_TIME=$(date +\%H:\%M:\%S)'

  if [ "$(id -u)" -eq 0 ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[0;33m\]$(git_branch) \[\033[38;5;129m\]$PROMPT_TIME\[\033[00m\] \$ '
  else
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[0;33m\]$(git_branch) \[\033[38;5;129m\]$PROMPT_TIME\[\033[00m\] \$ '
  fi
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(git_branch) \[\033[38;5;129m\]$PROMPT_TIME\[\033[00m\] \$ '
fi
unset color_prompt force_color_prompt
# Título do terminal.
case "$TERM" in
xterm*|rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*)
  ;;
esac
# Cores para os comandos de diretório e "grep".
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi
# Cores no GCC (compilador).
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
# Carrega aliases personalizados, se houver o arquivo ".bash_aliases".
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi
# Carrega o bash-completion, se disponível.
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

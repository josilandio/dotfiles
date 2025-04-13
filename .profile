# Shells de login.
# Verifica se o shell atual é o Bash.
if [ -n "$BASH_VERSION" ]; then
  # Se o arquivo ".bashrc" existir no diretório home.
  if [ -f "$HOME/.bashrc" ]; then
	  . "$HOME/.bashrc"
  fi
fi
# Se existir, adicionado ao PATH: "bin", ".local/bin"
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ] ; then
  PATH="$HOME/.local/bin:$PATH"
fi

setopt extended_glob
export DISABLE_LS_COLORS=true

export ZSH_THEME="robbyrussell"

export ZSH=$HOME/.oh-my-zsh
source ~/.oh-my-zsh/oh-my-zsh.sh
export ZSH=$HOME/.zsh

export DOTFILES=$HOME/code/dotfiles

export PROJECTS=~/code

# use .localrc for secret info
if [[ -a ~/.localrc ]]
then
  source ~/.localrc
fi

typeset -U dotfile_configs
typeset -U zsh_config

zsh_configs=($ZSH/*.zsh)
dotfile_configs=($DOTFILES/^zsh/.*/*.zsh)

configs=($zsh_configs $dotfile_configs)

for config_files in $configs
do
  # load the startup files
  for file in ${(M)config_files:#*/startup.zsh}
  do
    source $file
  done

  # load the path files
  for file in ${(M)config_files:#*/path.zsh}
  do
    source $file
  done

  # load everything but the path and completion files
  for file in ${${config_files:#*/path.zsh}:#*/completion.zsh}
  do
    source $file
  done

  # initialize autocomplete here, otherwise functions won't be loaded
  autoload -U compinit -u

  compinit -u

  # load every completion after autocomplete loads
  for file in ${(M)config_files:#*/completion.zsh}
  do
    source $file
  done
done

unset config_files
unset configs

export RBENV_ROOT=/usr/local/var/rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

GPG_TTY=$(tty)
export GPG_TTY
eval $(gpg-agent --daemon)

source ~/code/powerline/powerline/bindings/zsh/powerline.zsh

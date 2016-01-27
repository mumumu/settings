#!/bin/sh

#
#  mumumu's minimal dev environment
#
#  config.vm.provision :shell, :privileged => false, :path => "~/dev/mumumu_build_devenv.sh", :args => 'mumumu'
#

USER=$1
if [ -z $1 ]; then
    USER='mumumu'
fi

cd /home/$USER
git clone git@github.com:mumumu/settings.git settings
chown -R $USER.$USER settings
git clone https://github.com/Shougo/neobundle.vim.git ~/.vim/neobundle.vim.git
chown -R $USER.$USER ~/.vim/

rm -rf .bashrc
ln -s settings/dotfiles/bashrc .bashrc
chown $USER.$USER .bashrc
ln -s settings/dotfiles/gitconfig .gitconfig
chown $USER.$USER .gitconfig
ln -s settings/dotfiles/vimrc .vimrc
chown $USER.$USER .vimrc

sudo apt-get install -y ranger

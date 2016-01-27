#!/bin/sh

#
#  mumumu's custom environment template
#
#  config.vm.provision :shell, :privileged => false, :path => "~/dev/mumumu_build_devenv.sh", :args => 'mumumu'
#  config.vm.provision :shell, :privileged => false, :path => "~/dev/mumumu_build_devenv_custom.sh", :args => 'mumumu'
#


USER=$1
if [ -z $1 ]; then
    USER='mumumu'
fi

cat << EOT > /home/$USER/.bashrc_custom
#!/bin/sh

echo 'please insert some custom for specific environment'
EOT
chown $USER.$USER .bashrc_custom

class ubuntu::desktop {

    define download_and_install_dpkg($cmd_name, $deb_local_save_path, $url) {
        exec { "wget -O $deb_local_save_path $url":
            unless => "/usr/bin/which $cmd_name"
        }
        exec { "dpkg -i $deb_local_save_path":
            unless  => "/usr/bin/which $cmd_name",
            require => Exec["wget -O $deb_local_save_path $url"],
        }
        file {$deb_local_save_path:
            ensure  => absent,
            require => Exec["dpkg -i $deb_local_save_path"],
        }
    }

    package {[
        'build-essential',
        'git',
        'ctags',
        'python-virtualenv',
        'vim-nox',
        'wget',
        'keepass2',
        'sylpheed',
        'gimp',
        'vpnc',
        'fontforge',
        'keychain']:
        ensure => installed,
    }

    download_and_install_dpkg {
        'dropbox':
            cmd_name            => 'dropbox',
            deb_local_save_path => '/tmp/dropbox.deb',
            url                 => 'https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_1.6.0_amd64.deb';

        'virtualbox':
            cmd_name            => 'virtualbox',
            deb_local_save_path => '/tmp/virtualbox-4.2.deb',
            url                 => 'http://download.virtualbox.org/virtualbox/4.2.24/virtualbox-4.2_4.2.24-92790~Ubuntu~raring_amd64.deb';
    }
}

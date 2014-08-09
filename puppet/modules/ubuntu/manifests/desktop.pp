class ubuntu::desktop {

    define download_and_install_dpkg($cmd_name, $deb_local_save_path, $deb_download_url) {
        $wget_cmd = "wget -O $deb_local_save_path $deb_download_url"
        $dpkg_cmd = "dpkg -i $deb_local_save_path" 
        $existence_check_cmd = "/usr/bin/which $cmd_name"

        exec { $wget_cmd:
            unless => $existence_check_cmd,
        }
        exec { $dpkg_cmd:
            unless => $existence_check_cmd,
            require => Exec[$wget_cmd],
        }
        file {$deb_local_save_path:
            ensure  => absent,
            require => Exec[$dpkg_cmd],
        }
    }

    package {[
        'build-essential',
        'git',
        'lv',
        'ctags',
        'python-virtualenv',
        'vim-nox',
        'wget',
        'keepass2',
        'sylpheed',
        'gimp',
        'vpnc',
        'fontforge',
        'konversation',
        'keychain']:
        ensure => installed,
    }

    download_and_install_dpkg {
        'dropbox':
            cmd_name            => 'dropbox',
            deb_local_save_path => '/tmp/dropbox.deb',
            deb_download_url    => 'https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_1.6.0_amd64.deb';

        'virtualbox':
            cmd_name            => 'virtualbox',
            deb_local_save_path => '/tmp/virtualbox-4.2.deb',
            deb_download_url    => 'http://download.virtualbox.org/virtualbox/4.3.14/virtualbox-4.3_4.3.14-95030~Ubuntu~raring_amd64.deb';
    }
}

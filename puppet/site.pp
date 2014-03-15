Exec {
    path => '/bin:/sbin:/usr/bin:/usr/local/bin:/usr/sbin/'
}

User {
    managehome => true
}

class linux::ubuntu::user {

    define git_clone_from_github($path, $dir_fullpath, $username) {
        exec { $dir_fullpath:
            command => "git clone http://github.com/$path $dir_fullpath",
            unless  => "test -d $dir_fullpath",
            notify  => File[$dir_fullpath]
        }
        file {$dir_fullpath:
            owner => $username
        }
    }

    Git_clone_from_github {
        require => Package['git'],
    }

    define linux::user::resource($username) {

        git_clone_from_github {"neobundle_$username":
            path         => 'Shougo/neobundle.vim.git',
            dir_fullpath => "/home/$username/.vim/neobundle.vim.git",
            username     => $username,
        }

        git_clone_from_github {"rbenv_$username":
            path         => 'sstephenson/rbenv.git',
            dir_fullpath => "/home/$username/.rbenv",
            username     => $username,
        }

        git_clone_from_github {"ruby-build_$username":
            path         => 'sstephenson/ruby-build.git',
            dir_fullpath => "/home/$username/.rbenv/plugins/ruby-build",
            username     => $username,
        }

        git_clone_from_github {"settings_$username":
            path         => 'mumumu/settings.git',
            dir_fullpath => "/home/$username/settings",
            username     => $username,
        }

        file {"/home/$username/.vimrc":
            ensure  => 'link',
            target  =>  "/home/$username/settings/dotfiles/vimrc",
            require => Git_clone_from_github["settings_$username"],
            owner   => $username,
        }

        file {"/home/$username/.gitconfig":
            ensure  => 'link',
            target  =>  "/home/$username/settings/dotfiles/gitconfig",
            require => Git_clone_from_github["settings_$username"],
            owner   => $username,
        }

        file {"/home/$username/.bashrc":
            ensure  => 'link',
            target  =>  "/home/$username/settings/dotfiles/bashrc",
            require => Git_clone_from_github["settings_$username"],
            owner   => $username,
        }
    }

    user {'mumumu':
        ensure => present
    }

    linux::user::resource {'mumumu':
        username => 'mumumu',
        require  => User['mumumu']
    }
}

class linux::ubuntu::system {

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

    download_and_install_dpkg {'virtualbox':
        cmd_name            => 'virtualbox',
        deb_local_save_path => '/tmp/virtualbox-4.2.deb',
        url                 => 'http://download.virtualbox.org/virtualbox/4.2.24/virtualbox-4.2_4.2.24-92790~Ubuntu~raring_amd64.deb',
    }

    download_and_install_dpkg {'dropbox':
        cmd_name            => 'dropbox',
        deb_local_save_path => '/tmp/dropbox.deb',
        url                 => 'https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_1.6.0_amd64.deb'
    }
}

include linux::ubuntu::system
include linux::ubuntu::user

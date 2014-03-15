class ubuntu::user {

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

    define ubuntu::user::resource($username) {

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

    ubuntu::user::resource {'mumumu':
        username => 'mumumu',
        require  => User['mumumu']
    }
}

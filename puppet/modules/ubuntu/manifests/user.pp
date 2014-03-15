class ubuntu::user {

    define git_clone_from_github($path, $dir_fullpath, $dir_owner) {
        exec { $dir_fullpath:
            command => "git clone http://github.com/$path $dir_fullpath",
            unless  => "test -d $dir_fullpath",
            notify  => File[$dir_fullpath]
        }
        file {$dir_fullpath:
            owner => $dir_owner
        }
    }

    Git_clone_from_github {
        require => Package['git'],
    }

    define ubuntu::user::resource($username) {
        git_clone_from_github {
            "neobundle_$username":
                path         => 'Shougo/neobundle.vim.git',
                dir_fullpath => "/home/$username/.vim/neobundle.vim.git",
                dir_owner    => $username ;

            "rbenv_$username":
                path         => 'sstephenson/rbenv.git',
                dir_fullpath => "/home/$username/.rbenv",
                dir_owner    => $username ;

            "ruby-build_$username":
                path         => 'sstephenson/ruby-build.git',
                dir_fullpath => "/home/$username/.rbenv/plugins/ruby-build",
                dir_owner    => $username ;

            "settings_$username":
                path         => 'mumumu/settings.git',
                dir_fullpath => "/home/$username/settings",
                dir_owner    => $username ;
        }

        file {
            "/home/$username/.vimrc":
                ensure  => 'link',
                target  =>  "/home/$username/settings/dotfiles/vimrc",
                require => Git_clone_from_github["settings_$username"],
                owner   => $username ;

            "/home/$username/.gitconfig":
                ensure  => 'link',
                target  =>  "/home/$username/settings/dotfiles/gitconfig",
                require => Git_clone_from_github["settings_$username"],
                owner   => $username ;

            "/home/$username/.bashrc":
                ensure  => 'link',
                target  =>  "/home/$username/settings/dotfiles/bashrc",
                require => Git_clone_from_github["settings_$username"],
                owner   => $username ;
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

class linux::user {

    define git_clone_from_github($path, $dir_fullpath, $dir_owner) {
        $gitclone_cmd = "git clone http://github.com/$path $dir_fullpath"
        $chown_cmd = "chown -R $dir_owner.$dir_owner $dir_fullpath"
        exec { $gitclone_cmd:
            unless  => "test -d $dir_fullpath",
            notify => Exec[$chown_cmd],
        }

        #  Yes, we can set the following, but on Puppet 3,  it's 
        #  extremely slow for big directory tree...
        #
        #  file { $dir_fullpath:
        #    ensure   => directory,
        #    owner    => $dir_owner,
        #    group    => $dir_owner,
        #    recurse  => true,
        #  }
        exec { $chown_cmd:
            unless  => "/usr/bin/stat -c %U $dir_fullpath | grep $dir_owner",
        }
    }

    Git_clone_from_github {
        require => Package['git'],
    }

    define linux::user::resource($username, $ssh_public_key, $ssh_key_type) {
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
                dir_owner    => $username,
                require      => Git_clone_from_github["rbenv_$username"] ;

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

            "/home/$username/.gitignore":
                ensure  => 'link',
                target  =>  "/home/$username/settings/dotfiles/gitignore",
                require => Git_clone_from_github["settings_$username"],
                owner   => $username ;

            "/home/$username/.bashrc":
                ensure  => 'link',
                target  =>  "/home/$username/settings/dotfiles/bashrc",
                require => Git_clone_from_github["settings_$username"],
                owner   => $username ;
        }
      
        ssh_authorized_key { "ssh_public_key_$username":
            ensure => present,
            key    => $ssh_public_key,
            user   => $username,
            type   => $ssh_key_type,
        }
    }

    user {'mumumu':
        ensure => present
    }

    linux::user::resource {'mumumu':
        username       => 'mumumu',
        require        => User['mumumu'],
        ssh_public_key => 'AAAAB3NzaC1kc3MAAACBAMaLaD38tzFqrpPBrmg6GKeXK46fyKGg21oXX+tyP6AIZ+qbQeUfYmTyRLteUZqUJgMybCaTEqejRu3K0i6ZP6W49iJE644rvmUKX1uZBPFY0JZZ7afxlHjT3T2CfN0F4hRwwGhj3cyMIdwjqj97hcv1knVjvCBSBwtQNyW7VvVNAAAAFQC9snoTA6HXu4C1LEbp3VSZUNGUMQAAAIALJFml4BP9nDwt4TzRn8nQtmdkM+G/Oq3bh8Db4RGERyn8KDzJFSCcqv7W+e6ROvEGLijPgJwtQamfLUQOAbaoyaw3piykDmX7Yz9DunFwL/tCpWwlppX3mACA7tSOGsO8QpmJMqrAoToizDKsn3p7EPrbXGlgvktEVoSV4HcigAAAAIBs0zuwkaZ5tPuDitpuUgvVkhdsmyXGJqLNXyxi0xSVqqOMyFznireGzQunXDWr0pGqkjSXU2et1gFGP+T0bPjDDm+B5JsvoQ1XM2qiNbk0pXuOwRvSng4YHrZtqCmyh4kbOJY8tCasUC/FJNkIA626a7ZYZ5RKDsiBMmnsV8XbGA==',
        ssh_key_type   => 'ssh-dss'
    }
}

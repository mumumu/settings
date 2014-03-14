$user = 'mumumu'

Exec {
    path => '/bin:/sbin:/usr/bin:/usr/local/bin:/usr/sbin/'
}

define git_clone_from_github($path, $dir_fullpath) {
    exec { $path:
        command => "git clone http://github.com/$path $dir_fullpath",
        unless => "test -d $dir_fullpath"
    }
    file {$dir_fullpath:
        owner => $user
    }
}

Git_clone_from_github {
   require => Package['git']
}

define download_and_install_dpkg($cmd_name, $deb_local_save_path, $url) {
    exec { "wget -O $deb_local_save_path $url":
        unless => "/usr/bin/which $cmd_name"
    }
    exec { "dpkg -i $deb_local_save_path":
        unless => "/usr/bin/which $cmd_name"
    }
    file {$deb_local_save_path:
        ensure => absent
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

git_clone_from_github {'neobundle':
   path => 'Shougo/neobundle.vim.git',
   dir_fullpath => "/home/$user/.vim/neobundle.vim.git",
}

git_clone_from_github {'rbenv':
   path => 'sstephenson/rbenv.git',
   dir_fullpath => "/home/$user/.rbenv",
}

git_clone_from_github {'ruby-build':
   path => 'sstephenson/ruby-build.git',
   dir_fullpath => "/home/$user/.rbenv/plugins/ruby-build"
}

git_clone_from_github {'settings':
   path => 'mumumu/settings.git',
   dir_fullpath => "/home/$user/settings"
}

file {"/home/$user/.vimrc":
    ensure => 'link',
    target =>  "/home/$user/settings/dotfiles/vimrc",
    require => Git_clone_from_github['settings'],
    owner => $user
}

file {"/home/$user/.gitconfig":
    ensure => 'link',
    target =>  "/home/$user/settings/dotfiles/gitconfig",
    require => Git_clone_from_github['settings'],
    owner => $user
}

file {"/home/$user/.bashrc":
    ensure => 'link',
    target =>  "/home/$user/settings/dotfiles/bashrc",
    require => Git_clone_from_github['settings'],
    owner => $user
}

download_and_install_dpkg {'virtualbox':
    cmd_name => 'virtualbox',
    deb_local_save_path => '/tmp/virtualbox-4.2.deb',
    url => 'http://download.virtualbox.org/virtualbox/4.2.24/virtualbox-4.2_4.2.24-92790~Ubuntu~raring_amd64.deb',
}

download_and_install_dpkg {'dropbox':
    cmd_name => 'dropbox',
    deb_local_save_path => '/tmp/dropbox.deb',
    url => 'https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_1.6.0_amd64.deb'
}

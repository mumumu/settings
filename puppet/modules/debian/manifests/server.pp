class debian::server {

    package {[
        'build-essential',
        'git',
        'ctags',
        'python-virtualenv',
        'vim-nox',
        'wget']:
        ensure => installed,
    }
}

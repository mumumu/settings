class ubuntu::server {

    package {[
        'build-essential',
        'git',
        'lv',
        'ctags',
        'python-virtualenv',
        'vim-nox',
        'wget',
        'ranger',
        'highlight',
        'keychain']:
        ensure => installed,
    }

}

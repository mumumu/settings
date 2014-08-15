class ubuntu::googlechrome {

    $import_apt_key_cmd = "wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -"
    $google_apt_key_existence_check_cmd = "apt-key list | grep linux-packages-keymaster@google.com"
    exec { $import_apt_key_cmd:
        unless => $google_apt_key_existence_check_cmd,
    }

    $create_google_apt_list_cmd = "sudo sh -c 'echo \"deb http://dl.google.com/linux/chrome/deb/ stable main\" >> /etc/apt/sources.list.d/google.list'"
    exec { $create_google_apt_list_cmd:
        unless => "test -f /etc/apt/sources.list.d/google.list",
        require => Exec[$import_apt_key_cmd],
    }

    $chrome_update_resource = "apt-get update for google chrome installation"
    exec { $chrome_update_resource:
        command => "apt-get update",
        unless => "test -f /etc/apt/sources.list.d/google.list",
        require => Exec[$create_google_apt_list_cmd],
    }

    package { "google-chrome-stable":
        ensure => installed,
        require => Exec[$chrome_update_resource],
    }
}

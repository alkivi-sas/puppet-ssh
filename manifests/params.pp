class ssh::params () {
  case $::operatingsystem {
    /(Ubuntu|Debian)/: {
      $ssh_service_config = '/etc/ssh/sshd_config'
      $ssh_service_name   = 'ssh'
      $ssh_package_name   = 'openssh-server'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}


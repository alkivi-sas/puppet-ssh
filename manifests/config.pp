class ssh::config () {
  file {  $ssh::params::ssh_service_config:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('ssh/sshd_config.erb'),
    notify  => Class['ssh::service'],
  }
}

class ssh::config () {
  File {
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
  }

  file {  $ssh::params::ssh_service_config:
    content => template('ssh/sshd_config.erb'),
    notify  => Class['ssh::service'],
  }

  if defined(Package['alkivi-iptables'])
  {
    file { '/etc/iptables.d/10-ssh.rules':
      content => template('ssh/iptables.rules.erb'),
      require => Package['alkivi-iptables'],
      notify  => Service['alkivi-iptables'],
    }
  }
}

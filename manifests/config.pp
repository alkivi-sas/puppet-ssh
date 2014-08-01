class ssh::config (
    $port                    = $ssh::port,
    $permit_root             = $ssh::permit_root,
    $permit_empty_passwords  = $ssh::permit_empty_passwords,
    $challenge_response      = $ssh::challenge_response,
    $password_authentication = $ssh::password_authentication,
    $subsystem_sftp          = $ssh::subsystem_sftp,
    $use_pam                 = $ssh::use_pam,
    $verify_reverse_mapping  = $ssh::verify_reverse_mapping,
    $extra_configuration     = $ssh::extra_configuration,
    $allowed_extra           = $ssh::allowed_extra,
) {
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

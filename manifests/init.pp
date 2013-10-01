class ssh (
  $allowed_extra           = [
    '37.59.55.90',
    '188.165.205.152',
    '91.121.171.211' ],
  $port                    = 2202,
  $permit_root             = 'no',
  $password_authentication = 'no',
  $motd                    = true,
) {

  if($motd)
  {
    motd::register{ 'SSH Server': }
  }

  validate_array($allowed_extra)
  validate_string($port)
  validate_string($permit_root)
  validate_string($password_authentication)


  # declare all parameterized classes
  class { 'ssh::params': }
  class { 'ssh::install': }
  class { 'ssh::config': }
  class { 'ssh::service': }

  # declare relationships
  Class['alkivi_base'] ->
  Class['ssh::params'] ->
  Class['ssh::install'] ->
  Class['ssh::config'] ->
  Class['ssh::service']

  if defined(Class['fail2ban'])
  {
    fail2ban::section{'ssh':
      content => "
enabled  = true
port     = ${port}
filter   = sshd
logpath  = /var/log/auth.log
maxretry = 6"
    }

    fail2ban::section{'ssh-ddos':
      content => "
enabled  = true
port     = ${port}
filter   = sshd-ddos
logpath  = /var/log/auth.log
maxretry = 6"
    }
  }
}


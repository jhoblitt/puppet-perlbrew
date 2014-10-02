# == Define: perlbrew
#
define perlbrew (
  $install_root  = '/usr/local/perlbrew',
  $owner         = undef,
  $group         = undef,
  $bashrc        = false,
) {
  validate_absolute_path($install_root)
  validate_string($owner)
  validate_string($group)
  validate_bool($bashrc)

  include ::wget

  exec { "${name}_install_perlbrew":
    command     => 'wget --no-check-certificate -O - http://install.perlbrew.pl | bash',
    path        => ['/bin', '/usr/bin'],
    environment => ["HOME=${install_root}"],
    cwd         => $install_root,
    user        => $owner,
    group       => $group,
    logoutput   => true,
    creates     => "${install_root}/perl5/perlbrew/bin/perlbrew",
  }

  if $bashrc {
    $bashrc_path = "${install_root}/.bashrc"

    Exec["${name}_install_perlbrew"] ->
    # the file_line type does not handle ownership
    file { "${name}_perlbrew_bashrc":
      ensure => file,
      path   => $bashrc_path,
      owner  => $owner,
      group  => $group,
      mode   => '0644',
    } ->
    file_line { "${name}_perlbrew_bashrc":
      path => "${install_root}/.bashrc",
      line => "source ${install_root}/perl5/perlbrew/etc/bashrc",
    }
  }
}

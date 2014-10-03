# == Define: perlbrew::perl
#
define perlbrew::perl (
  $target,
  $version = $name,
) {
  validate_string($name)
  validate_string($target)

  Perlbrew[$target] -> Perlbrew::Perl[$name]

  $install_root = getparam(Perlbrew[$target], 'install_root')
  $owner        = getparam(Perlbrew[$target], 'owner')
  $group        = getparam(Perlbrew[$target], 'group')

  exec { "${target}_install_perl-${version}":
    command     => "perlbrew install perl-${version}",
    path        => ['/bin', '/usr/bin', "${install_root}/perl5/perlbrew/bin"],
    environment => ["HOME=${install_root}"],
    cwd         => $install_root,
    user        => $owner,
    group       => $group,
    logoutput   => true,
    creates     => "${install_root}/perl5/perlbrew/perls/perl-${version}",
  } ->
  exec { "${target}_switch_perl-${version}":
    command     => "perlbrew switch perl-${version}",
    path        => ['/bin', '/usr/bin', "${install_root}/perl5/perlbrew/bin"],
    environment => ["HOME=${install_root}", 'PERLBREW_BASHRC_VERSION=0.71'],
    cwd         => $install_root,
    user        => $owner,
    group       => $group,
    logoutput   => true,
    unless      => "grep PERLBREW_PERL=\\\"perl-${version}\\\" ${install_root}/.perlbrew/init",
  }
}

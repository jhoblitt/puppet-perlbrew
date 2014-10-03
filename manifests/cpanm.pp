# == Define: perlbrew::cpanm
#
define perlbrew::cpanm (
  $target,
  $module = $name,
  $check_name = undef,
) {
  validate_string($name)
  validate_string($target)
  validate_string($module)
  validate_string($check_name)

  Perlbrew::Perl[$target] -> Perlbrew::Cpanm[$name]

  $perl_target  = getparam(Perlbrew::Perl[$target], 'target')
  $version      = getparam(Perlbrew::Perl[$target], 'version')
  $install_root = getparam(Perlbrew[$perl_target], 'install_root')
  $owner        = getparam(Perlbrew[$perl_target], 'owner')
  $group        = getparam(Perlbrew[$perl_target], 'group')

  $perlbrew_env = [
    "HOME=${install_root}",
    'PERLBREW_VERSION=0.71',
    "PERLBREW_PERL=perl-${version}",
    'PERLBREW_BASHRC_VERSION=0.71',
    "PERLBREW_ROOT=${install_root}/perl5/perlbrew",
    "PERLBREW_HOME=${install_root}/.perlbrew",
    "PERLBREW_MANPATH=${install_root}/perl5/perlbrew/perls/perl-${version}/man",
    "PERLBREW_PATH=${install_root}/perl5/perlbrew/bin:${install_root}/perl5/perlbrew/perls/perl-${version}/bin",
  ]

  $perlbrew_path = [
    "${install_root}/perl5/perlbrew/bin",
    "${install_root}/perl5/perlbrew/perls/perl-${version}/bin",
    '/bin',
    '/usr/bin',
  ]

  $testfor = $check_name ? {
    undef   => $module,
    default => $check_name,
  }

  exec { "${target}_cpanm-${module}":
    command     => "cpanm ${module}",
    path        => $perlbrew_path,
    environment => $perlbrew_env,
    cwd         => $install_root,
    user        => $owner,
    group       => $group,
    logoutput   => true,
    unless      => "perl -M${testfor} -e '1'",
    timeout     => 900,
  }
}

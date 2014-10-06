# == Define: perlbrew::exec
#
define perlbrew::exec (
  $target,
  $command     = $name,
  $creates     = undef,
  $environment = undef,
  $logoutput   = undef,
  $onlyif      = undef,
  $path        = undef,
  $provider    = undef,
  $refresh     = undef,
  $refreshonly = undef,
  $returns     = undef,
  $timeout     = undef,
  $tries       = undef,
  $try_sleep   = undef,
  $umask       = undef,
  $unless      = undef,
) {
  validate_string($name)
  validate_string($target)
  validate_string($command)

  Perlbrew::Perl[$target] -> Perlbrew::Exec[$name]

  $perl_target  = getparam(Perlbrew::Perl[$target], 'target')
  $version      = getparam(Perlbrew::Perl[$target], 'version')
  $install_root = getparam(Perlbrew[$perl_target], 'install_root')
  $owner        = getparam(Perlbrew[$perl_target], 'owner')
  $group        = getparam(Perlbrew[$perl_target], 'group')

  # this is duplicative of the environment setup done in perlbrew::perl but
  # this can't be avoided due to puppet 3.x's inaccessible defined type scopes
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
  ]

  $merged_environment = $environment ? {
    undef   => $perlbrew_env,
    default => concat($perlbrew_env, $environment),
  }

  $merged_path = $path? {
    undef   => $perlbrew_path,
    default => concat($perlbrew_path, $path),
  }

  exec { "${target}_${command}":
    command     => $command,
    creates     => $creates,
    cwd         => $install_root,
    environment => $merged_environment,
    group       => $group,
    logoutput   => $logoutput,
    onlyif      => $onlyif,
    path        => $merged_path,
    provider    => $provider,
    refresh     => $refresh,
    refreshonly => $refreshonly,
    returns     => $returns,
    timeout     => $timeout,
    tries       => $tries,
    try_sleep   => $try_sleep,
    umask       => $umask,
    unless      => $unless,
    user        => $owner,
  }
}

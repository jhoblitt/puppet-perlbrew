# == Define: perlbrew::perl
#
define perlbrew::perl (
  $target,
  $version = $name,
  $as      = undef,
  $flags   = "--notest -j ${::processorcount}",
  $timeout = 900,
) {
  validate_string($target)
  validate_string($version)
  validate_string($as)
  validate_string($flags)
  validate_string($timeout)


  Perlbrew[$target] -> Perlbrew::Perl[$name]

  $install_root = getparam(Perlbrew[$target], 'install_root')
  $owner        = getparam(Perlbrew[$target], 'owner')
  $group        = getparam(Perlbrew[$target], 'group')

  # this is duplicative of the environment setup done in perlbrew::exec but
  # this can't be avoided due to puppet 3.x's inaccessible defined type scopes
  $perlbrew_env = [
    "HOME=${install_root}",
    'PERLBREW_VERSION=0.71',
    "PERLBREW_PERL=${version}",
    'PERLBREW_BASHRC_VERSION=0.71',
    "PERLBREW_ROOT=${install_root}/perl5/perlbrew",
    "PERLBREW_HOME=${install_root}/.perlbrew",
    "PERLBREW_MANPATH=${install_root}/perl5/perlbrew/perls/${version}/man",
    "PERLBREW_PATH=${install_root}/perl5/perlbrew/bin:${install_root}/perl5/perlbrew/perls/${version}/bin",
  ]

  $perlbrew_path = [
    "${install_root}/perl5/perlbrew/bin",
    "${install_root}/perl5/perlbrew/perls/${version}/bin",
    '/bin',
    '/usr/bin',
  ]

  if $as {
    $alias = $as
    $command = regsubst("perlbrew install --as ${as} ${flags} ${version}", '\s+', ' ', 'G')
  }
  else {
    $command = regsubst("perlbrew install ${flags} ${version}", '\s+', ' ', 'G')
    $alias = $version
  }

  exec { "${target}_install_${version}":
    command     => $command,
    path        => $perlbrew_path,
    environment => $perlbrew_env,
    cwd         => $install_root,
    user        => $owner,
    group       => $group,
    logoutput   => true,
    creates     => "${install_root}/perl5/perlbrew/perls/${version}",
    timeout     => $timeout,
  } ->
  exec { "${target}_install-cpanm-${version}":
    command     => 'perlbrew install-cpanm',
    path        => $perlbrew_path,
    environment => $perlbrew_env,
    cwd         => $install_root,
    user        => $owner,
    group       => $group,
    logoutput   => true,
    unless      => 'which cpanm',
  } ->
  exec { "${target}_switch_${alias}":
    command     => "perlbrew switch ${alias}",
    path        => $perlbrew_path,
    environment => $perlbrew_env,
    cwd         => $install_root,
    user        => $owner,
    group       => $group,
    logoutput   => true,
    unless      => "grep PERLBREW_PERL=\\\"${alias}\\\" ${install_root}/.perlbrew/init",
  }
}

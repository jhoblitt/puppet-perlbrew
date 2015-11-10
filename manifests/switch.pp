# == Define: perlbrew::switch
#
define perlbrew::switch(
  $target  = $title,
  $version = 'system',
) {

  validate_string($target, $version)

  $install_root = getparam(Perlbrew[$target], 'install_root')
  $owner        = getparam(Perlbrew[$target], 'owner')
  $group        = getparam(Perlbrew[$target], 'group')

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

  if $version == 'system' {
    exec { "${target}_switch_${version}":
      command     => 'perlbrew switch-off',
      path        => $perlbrew_path,
      environment => $perlbrew_env,
      cwd         => $install_root,
      user        => $owner,
      group       => $group,
      logoutput   => true,
      onlyif      => "grep 'PERLBREW_PERL=' ${install_root}/.perlbrew/init",
    }
  }
  else {
    exec { "${target}_switch_${version}":
      command     => "perlbrew switch ${version}",
      path        => $perlbrew_path,
      environment => $perlbrew_env,
      cwd         => $install_root,
      user        => $owner,
      group       => $group,
      logoutput   => true,
      unless      => "grep PERLBREW_PERL=\\\"${version}\\\" ${install_root}/.perlbrew/init",
      require     => Exec["${target}_install-cpanm-${version}"],
    }
  }
}

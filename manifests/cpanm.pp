# == Define: perlbrew::cpanm
#
define perlbrew::cpanm (
  $target,
  $module     = $name,
  $flags      = '--notest',
  $path       = ['/bin', '/usr/bin'],
  $check_name = undef,
  $timeout    = undef,
) {
  validate_string($name)
  validate_string($target)
  validate_string($module)
  validate_string($flags)
  validate_array($path)
  validate_string($check_name)
  validate_string($timeout)

  $testfor = $check_name ? {
    undef   => $module,
    default => $check_name,
  }

  $command = regsubst("cpanm ${flags} ${module}", '\s+', ' ', 'G')

  perlbrew::exec { $command:
    target    => $target,
    # needs path to git, chmod, make, etc.
    path      => $path,
    logoutput => true,
    timeout   => $timeout,
    unless    => "perl -M${testfor} -e '1'",
  }
}

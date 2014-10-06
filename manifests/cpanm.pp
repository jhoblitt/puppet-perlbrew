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

  $testfor = $check_name ? {
    undef   => $module,
    default => $check_name,
  }

  perlbrew::exec { "cpanm ${module}":
    target    => $target,
    logoutput => true,
    unless    => "perl -M${testfor} -e '1'",
    timeout   => 900,
  }
}

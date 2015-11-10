Puppet perlbrew Module
======================

[![Build Status](https://travis-ci.org/jhoblitt/puppet-perlbrew.png)](https://travis-ci.org/jhoblitt/puppet-perlbrew)

#### Table of Contents

1. [Overview](#overview)
2. [Description](#description)
3. [Usage](#usage)
    * [Examples](#examples)
        * [Single Perl Environment](#single-perl-environment)
        * [Multiple Perl Environments](#multiple-perl-environments)
        * [Install Module from Git](#install-module-from-git)
        * [Building an Application](#building-an-application)
    * [Defines](#defines)
        * [`perlbrew`](#perlbrew)
        * [`perlbrew::perl`](#perlbrewperl)
        * [`perlbrew::switch`](#perlbrewswitch)
        * [`perlbrew::cpanm`](#perlbrewcpanm)
        * [`perlbrew::exec`](#perlbrewexec)
4. [Limitations](#limitations)
    * [Tested Platforms](#tested-platforms)
5. [Versioning](#versioning)
6. [Support](#support)
7. [See Also](#see-also)


Overview
--------

Manages `perlbrew` based Perl5 installations


Description
-----------

This is a puppet module for basic management of
[`perlbrew`](http://perlbrew.pl/) based Perl5 installations.  It has the
ability to manage multiple parallel installations on the same host.

**Several of the types in this module have parse order dependent behavior.
Please observe any warning(s) listed in a type's description below**


Usage
-----

### Examples

#### Single Perl Environment

```puppet
perlbrew { '/home/moe':
  owner  => 'moe',
  group  => 'stoges',
  bashrc => true,
}

perlbrew::perl { 'perl-5.20.1':
  target => '/home/moe',
}

perlbrew::cpanm { 'Module::Build':
  target => 'perl-5.20.1',
}
```

#### Multiple Perl Environments

```puppet
perlbrew { '/home/moe':
  owner => 'moe',
}
perlbrew { '/home/larry':
  owner => 'larry',
}
perlbrew { '/home/curly':
  owner => 'curly',
}

perlbrew::perl { 'moe-5.20.1':
  target  => '/home/moe',
  version => 'perl-5.20.1',
}
perlbrew::perl { 'larry-5.20.1':
  target  => '/home/larry',
  version => 'perl-5.20.1',
}
perlbrew::perl { 'curly-5.20.1':
  target  => '/home/curly',
  version => 'perl-5.20.1',
}

perlbrew::cpanm { 'moe-Module::Build':
  target => 'moe-5.20.1',
  module => 'Module::Build',
}
perlbrew::cpanm { 'larry-Module::Build':
  target => 'larry-5.20.1',
  module => 'Module::Build',
}
perlbrew::cpanm { 'curly-Module::Build':
  target => 'curly-5.20.1',
  module => 'Module::Build',
}
```

#### Install Module from Git

```puppet
perlbrew::cpanm { 'git@github.com:jhoblitt/DateTime-Format-ISO8601.git':
  target => '5.20.1',
  module => 'DateTime::Format::ISO8601',
}
```

#### Building an Application

Example of building a perl application in place.

```puppet
$lockfile = "${app_root}/lock"

vcsrepo { $app_root:
  ensure   => present,
  provider => 'git',
  source   => '',
  user     => $app_user,
  owner    => $app_user,
  group    => $app_group,
} ->
perlbrew::exec { 'perl Build.PL':
  target  => 'perl-5.20.1',
  cwd     => $app_root
  creates => $lockfile,
  require => Perlbrew::Cpanm['Module::Build'],
} ->
perlbrew::exec { 'Build':
  target  => 'perl-5.20.1',
  cwd     => $app_root,
  path    => $app_root,
  creates => $lockfile,
} ->
perlbrew::exec { 'cpanm --installdeps --notest .':
  target  => 'perl-5.20.1',
  path    => ['/bin', '/usr/bin'],
  cwd     => $app_root,
  creates => $lockfile,
  timeout => 900,
} ->
file { $lockfile:
  ensure => 'file',
  owner  => $app_user,
  group  => $app_group,
}
```

### Defines

#### `perlbrew`

```puppet
# defaults
perlbrew { '/home/foo':
  install_root => '/home/foo', # defaults to resource title
  owner        => undef,
  group        => undef,
  bashrc       => false,
}

```

##### `install_root`

Absolute path. Defaults to `$name`

The root path of the perlbrew installation.  Optional if the resource title is a unique absolute path.

##### `owner`

`String` Defaults to `undef`

The user account that own's the perlbrew installation.

##### `group`

`String` Defaults to `undef`

The group that own's the perlbrew installation.

##### `bashrc`

`Boolean` Defaults to `false`

If set to `true`, a line to `source` the perlbrew bash init script is added to
the `.bashrc` file located under the `install` root.  Eg.

    source <source>/perl5/perlbrew/etc/bashrc


#### `perlbrew::perl`

**Warning**: This defined type has parse order dependent behavior.  The
`Perlbrew[$target]` resource must be *parsed* before this type's declaration.

```puppet
perlbrew::perl { 'perl-5.20.1':
  target  => '/home/moe', # required
  version => 'perl-5.20.1',
  flags   => "--notest -j ${::processorcount}",
  timeout => 900,
  switch  => true,
}
```

##### `target`

`String` Required

The name of the `Perlbrew[...]` resource / environment the declared version of perl should be installed under.

##### `version`

`String` Defaults to `$title`

The version string of perl 5 release to be installed. Eg.

    $ perlbrew available
      perl-5.20.1
      perl-5.18.4
      perl-5.16.3
      perl-5.14.4
      perl-5.12.5
      perl-5.10.1
      perl-5.8.9
      perl-5.6.2
      perl5.005_04
      perl5.004_05
      perl5.003_07

##### `flags`

`String` Defaults to `--notest -j ${::processorcount}`

The option flag(s) passed to `perlbrew install` command. Note that the
`--notest` flag dramatically speeds up the ammount of time require to install a
perl version.

##### `timeout`

`String` Defaults to `900`

This sets the timeout on the `perlbrew install` command.  It may be nessicary
to increase this value on a slow host or if the `--notest` flag is not being
passed.

##### `switch`

`Boolean` Defaults to `true`

This enables/disables automatic switching to the new perl during install.
Set to false if you want to manage the versions in use separately.

#### `perlbrew::switch`

**Warning**: This defined type has parse order dependent behavior.  The
`Perlbrew[$target]` resource must be *parsed* before this type's declaration.

```puppet
perlbrew::switch { '/home/moe':
  target  => '/home/moe',
  version => 'perl-5.20.1', #required
}
```

##### `target`

`String` Defaults to `$title`.

The name of the `Perlbrew[...]` resource / environment the switch is to be performed on.

##### `version`

`String` Required.

The version string of perl 5 release to be switched to.

#### `perlbrew::cpanm`

**Warning**: This defined type has parse order dependent behavior.  The
`Perlbrew::Perl[$target]` resource must be *parsed* before this type's
declaration.

```puppet
perlbrew::cpanm { 'Module::Build':
  target     =>'perl-5.20.1', # required
  module     => 'Module::Build', # defaults to resource title
  flags      => '--notest',
  check_name => undef,
  timeout    => undef,
}
```

##### `target`

`String` Required

The name of the `Perlbrew::Perl[...]` resource / perl installation to use.

##### `module`

`String` Defaults to `$title`

The module name to pass to the `cpanm` utility.

##### `flags`

`String` Defaults to `--notest`

The set of flag(s), as a string, to pass to `cpanm`.

##### `check_name`

`String` Defaults to `undef`

The name of the install perl lib to test for.  If left undef, `$module/$title`
is is tested for.  This is useful is the name of the installed library does not
match the git url / cpan tarball name. Eg.

```puppet
perlbrew::cpanm { 'https://github.com/Perl-Toolchain-Gang/Module-Build':
  target     =>'perl-5.20.1',
  check_name => 'Module::Build',
}

```

##### `timeout`

`String` Defaults to `undef`

The number of seconds the operation should wait before failing due to a
timeout.

#### `perlbrew::exec`

**Warning**: This defined type has parse order dependent behavior.  The
`Perlbrew::Perl[$target]` resource must be *parsed* before this type's
declaration.

```puppet
perlbrew::exec { 'perl Build.PL':
  target      => 'perl-5.20.1', # required
  command     => 'perl Build.PL',
  creates     => undef,
  cwd         => undef,
  environment => undef,
  logoutput   => undef,
  onlyif      => undef,
  path        => undef,
  provider    => undef,
  refresh     => undef,
  refreshonly => undef,
  returns     => undef,
  timeout     => undef,
  tries       => undef,
  try_sleep   => undef,
  umask       => undef,
  unless      => undef,
}
```

This defined type is a thin convenience wrapper around Puppet's core exec type.

##### `target`

`String` Required

The name of the `Perlbrew::Perl[...]` resource / perl installation to use.

##### Massaged parameters

Values passed to these parameters are merged with internal arrays before being
passed to the core `exec` type.

* `environment`
* `path`

##### Passed through parameters

These parameters behave identically to Puppet's core `exec` type:

* `command`
* `creates`
* `cwd`
* `logoutput`
* `onlyif`
* `provider`
* `refresh`
* `refreshonly`
* `returns`
* `timeout`
* `tries`
* `try_sleep`
* `umask`
* `unless`


Limitations
-----------

At present, this module is only capable of supporting one `perlbrew::perl`
installed perl version per `perlbrew` environment.  This is due to the logic
used in the `perlbrew::perl` define for the `perlbrew switch <version>` logic.
This should be relatively easy to change if one encounters that use case.


### Tested Platforms

 * el6.x

Versioning
----------

This module is versioned according to the [Semantic Versioning
2.0.0](http://semver.org/spec/v2.0.0.html) specification.


Support
-------

Please log tickets and issues at
[github](https://github.com/jhoblitt/puppet-perlbrew/issues)


See Also
--------

* [`perlbrew`](http://perlbrew.pl/)

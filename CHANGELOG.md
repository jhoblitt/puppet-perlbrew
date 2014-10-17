
#### [Current]
 * [768e006](../../commit/768e006) - __(Joshua Hoblitt)__ add sles/debian linux to operatingsystem_support metadata
 * [e055934](../../commit/e055934) - __(Joshua Hoblitt)__ update+add README examples
 * [b6ee28c](../../commit/b6ee28c) - __(Joshua Hoblitt)__ remove puppet 2.7.14 from travis matrix
 * [96774ab](../../commit/96774ab) - __(Joshua Hoblitt)__ Merge pull request [#2](../../issues/2) from jhoblitt/feature/perlbrew_perl_params

Feature/perlbrew perl params
 * [7b72c18](../../commit/7b72c18) - __(Joshua Hoblitt)__ add timeout param to perlbrew::perl

This change also shortens the default timeout on a perl install from
3600s -> 900s.

 * [de60e1f](../../commit/de60e1f) - __(Joshua Hoblitt)__ add flags param to perlbrew::perl

The flags param defaults to including the `--notest` flag which should
dramatically shorten the time required to install a new perl version.

+ greatly improved test coverage of perlbrew::perl

#### v0.3.0
 * [c20ffd3](../../commit/c20ffd3) - __(Joshua Hoblitt)__ bump version to v0.3.0
 * [c01f182](../../commit/c01f182) - __(Joshua Hoblitt)__ Merge pull request [#1](../../issues/1) from jhoblitt/feature/cpanm_params

add timeout & flags params to perlbrew::cpanm
 * [43b11f3](../../commit/43b11f3) - __(Joshua Hoblitt)__ add timeout & flags params to perlbrew::cpanm

#### v0.2.0
 * [9c740e8](../../commit/9c740e8) - __(Joshua Hoblitt)__ bump version to v0.2.0
 * [0d62542](../../commit/0d62542) - __(Joshua Hoblitt)__ remove debugging comments from perlbrew::exec

Never should have been committed...

 * [2a5b511](../../commit/2a5b511) - __(Joshua Hoblitt)__ set a default cwd for perlbrew::exec

This is to [hopefully] prevent the exec from having a cwd that the
user/group perms it's running with doesn't have access to.

#### v0.1.0
 * [3571557](../../commit/3571557) - __(Joshua Hoblitt)__ humans should never have to hand edit json...
 * [796dd2b](../../commit/796dd2b) - __(Joshua Hoblitt)__ add metadata.json for initial forge release
 * [ccf48cb](../../commit/ccf48cb) - __(Joshua Hoblitt)__ fix README example typo
 * [dc52547](../../commit/dc52547) - __(Joshua Hoblitt)__ minor README markup fixes
 * [66b32d4](../../commit/66b32d4) - __(Joshua Hoblitt)__ puppet < 3's exec type does not support the umask parameter
 * [c9e5b7b](../../commit/c9e5b7b) - __(Joshua Hoblitt)__ do not prefix perlbrew perl version string with perl-

Require the full perlbrew version string

 * [c4d392d](../../commit/c4d392d) - __(Joshua Hoblitt)__ fill out basic README structure
 * [c8e630b](../../commit/c8e630b) - __(Joshua Hoblitt)__ perlbrew::exec should not be forced to Perlbrew[$target]'s cwd
 * [6fe4729](../../commit/6fe4729) - __(Joshua Hoblitt)__ make rspec tests compatible with ruby 1.8.7 (again...)
 * [a837813](../../commit/a837813) - __(Joshua Hoblitt)__ add perlbrew::exec define

- refactor perlbrew::cpanm to use new define
- needs additional tests

 * [64e61e3](../../commit/64e61e3) - __(Joshua Hoblitt)__ make rspec tests compatible with ruby 1.8.7

Remove trailing commas from the last hash key...

 * [b28b77d](../../commit/b28b77d) - __(Joshua Hoblitt)__ change perlbrew install param to default to name/title
 * [2f46366](../../commit/2f46366) - __(Joshua Hoblitt)__ add perlbrew::cpanm define
 * [d1bcc7f](../../commit/d1bcc7f) - __(Joshua Hoblitt)__ pedantically replicate perlbrew env vars for perlbrew::perl
 * [1b59b58](../../commit/1b59b58) - __(Joshua Hoblitt)__ add perlbrew::perl define
 * [bd2db22](../../commit/bd2db22) - __(Joshua Hoblitt)__ set shell env HOME var when installing perlbrew
 * [6353948](../../commit/6353948) - __(Joshua Hoblitt)__ first working version
 * [ac2c584](../../commit/ac2c584) - __(Joshua Hoblitt)__ first commit

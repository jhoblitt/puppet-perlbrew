require 'spec_helper'

describe 'perlbrew::exec', :type => :define do
  let(:title) { 'perl Build.PL' }
  let(:pre_condition) do
    <<-eos
      perlbrew { '/dne': }
      perlbrew::perl { '5.18.2': target => '/dne' }
    eos
  end

  context 'default params' do
    let(:params) {{ :target => '5.18.2' }}

    install_root = '/dne'
    version = '5.18.2'

    perlbrew_env = [
      "HOME=#{install_root}",
      'PERLBREW_VERSION=0.71',
      "PERLBREW_PERL=perl-#{version}",
      'PERLBREW_BASHRC_VERSION=0.71',
      "PERLBREW_ROOT=#{install_root}/perl5/perlbrew",
      "PERLBREW_HOME=#{install_root}/.perlbrew",
      "PERLBREW_MANPATH=#{install_root}/perl5/perlbrew/perls/perl-#{version}/man",
      "PERLBREW_PATH=#{install_root}/perl5/perlbrew/bin:#{install_root}/perl5/perlbrew/perls/perl-#{version}/bin",
    ]

    perlbrew_path = [
      "#{install_root}/perl5/perlbrew/bin",
      "#{install_root}/perl5/perlbrew/perls/perl-#{version}/bin",
    ]

    it { should contain_exec('5.18.2_perl Build.PL').with(
        :command     => 'perl Build.PL',
        :cwd         => '/dne',
        :environment => perlbrew_env,
        :path        => perlbrew_path,
      )
    }
  end
end

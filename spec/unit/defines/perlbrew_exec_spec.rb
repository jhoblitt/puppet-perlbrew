require 'spec_helper'

describe 'perlbrew::exec', :type => :define do
  let(:title) { 'perl Build.PL' }
  let(:pre_condition) do
    <<-eos
      perlbrew { '/dne': }
      perlbrew::perl { 'perl-5.18.2': target => '/dne' }
    eos
  end

  context 'default params' do
    let(:params) {{ :target => 'perl-5.18.2' }}

    install_root = '/dne'
    version = 'perl-5.18.2'

    perlbrew_env = [
      "HOME=#{install_root}",
      'PERLBREW_VERSION=0.71',
      "PERLBREW_PERL=#{version}",
      'PERLBREW_BASHRC_VERSION=0.71',
      "PERLBREW_ROOT=#{install_root}/perl5/perlbrew",
      "PERLBREW_HOME=#{install_root}/.perlbrew",
      "PERLBREW_MANPATH=#{install_root}/perl5/perlbrew/perls/#{version}/man",
      "PERLBREW_PATH=#{install_root}/perl5/perlbrew/bin:#{install_root}/perl5/perlbrew/perls/#{version}/bin",
    ]

    perlbrew_path = [
      "#{install_root}/perl5/perlbrew/bin",
      "#{install_root}/perl5/perlbrew/perls/#{version}/bin",
    ]

    it { should contain_exec('perl-5.18.2_perl Build.PL').with(
        :command     => 'perl Build.PL',
        :environment => perlbrew_env,
        :path        => perlbrew_path
      )
    }
  end
end

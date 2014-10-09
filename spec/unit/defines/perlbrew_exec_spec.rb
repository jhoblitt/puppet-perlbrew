require 'spec_helper'

describe 'perlbrew::exec', :type => :define do
  let(:title) { 'perl Build.PL' }
  let(:params) {{ :target => 'perl-5.18.2' }}
  let(:pre_condition) do
    <<-eos
      perlbrew { '/dne': }
      perlbrew::perl { 'perl-5.18.2': target => '/dne' }
    eos
  end
  let(:install_root) { '/dne' }
  let(:version) { 'perl-5.18.2' }
  let(:perlbrew_env) { [
    "HOME=#{install_root}",
    'PERLBREW_VERSION=0.71',
    "PERLBREW_PERL=#{version}",
    'PERLBREW_BASHRC_VERSION=0.71',
    "PERLBREW_ROOT=#{install_root}/perl5/perlbrew",
    "PERLBREW_HOME=#{install_root}/.perlbrew",
    "PERLBREW_MANPATH=#{install_root}/perl5/perlbrew/perls/#{version}/man",
    "PERLBREW_PATH=#{install_root}/perl5/perlbrew/bin:#{install_root}/perl5/perlbrew/perls/#{version}/bin",
  ]}
  let(:perlbrew_path) {[
    "#{install_root}/perl5/perlbrew/bin",
    "#{install_root}/perl5/perlbrew/perls/#{version}/bin",
  ]}

  context 'default params' do
    it { should contain_exec('perl-5.18.2_perl Build.PL').with(
        :command     => 'perl Build.PL',
        :cwd         => install_root,
        :environment => perlbrew_env,
        :path        => perlbrew_path
      )
    }
  end

  context 'environemnt' do
    before { params[:environment] = ['FOO=bar'] }
    before { perlbrew_env << 'FOO=bar' }

    it { should contain_exec('perl-5.18.2_perl Build.PL').with(
        :command     => 'perl Build.PL',
        :cwd         => install_root,
        :environment => perlbrew_env,
        :path        => perlbrew_path
      )
    }
  end

  context 'path' do
    before { params[:path] = ['/dne'] }
    before { perlbrew_path << '/dne' }

    it { should contain_exec('perl-5.18.2_perl Build.PL').with(
        :command     => 'perl Build.PL',
        :cwd         => install_root,
        :environment => perlbrew_env,
        :path        => perlbrew_path
      )
    }
  end

  context 'cwd' do
    before { params[:cwd] = ['/dne/foo'] }

    it { should contain_exec('perl-5.18.2_perl Build.PL').with(
        :command     => 'perl Build.PL',
        :cwd         => '/dne/foo',
        :environment => perlbrew_env,
        :path        => perlbrew_path
      )
    }
  end
end

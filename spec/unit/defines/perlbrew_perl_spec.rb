require 'spec_helper'

describe 'perlbrew::perl', :type => :define do
  let(:facts) {{ :processorcount => 42 }}

  let(:install_root) { '/dne' }
  let(:version) { 'perl-5.18.2' }
  let(:target) { 'foo' }
  let(:flags) { "--notest -j #{facts[:processorcount]}" }
  let(:timeout) { 900 }

  let(:title) { version }
  let(:params) {{ :target => target }}
  let(:pre_condition) { "perlbrew { '#{target}': install_root => '#{install_root}' }" }

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
    '/bin',
    '/usr/bin',
  ]}

  shared_examples 'guts' do
    it { should contain_perlbrew__perl(title).that_requires("Perlbrew[#{target}]") }

    it { should contain_exec("#{target}_install_#{version}").with(
        :command     => "perlbrew install #{flags} #{version}",
        :path        => perlbrew_path,
        :environment => perlbrew_env,
        :cwd         => '/dne',
        :user        => nil,
        :group       => nil,
        :logoutput   => true,
        :creates     => "/dne/perl5/perlbrew/perls/#{version}",
        :timeout     => timeout
      )
    }

    it { should contain_exec("#{target}_install-cpanm-#{version}").with(
        :command     => 'perlbrew install-cpanm',
        :path        => perlbrew_path,
        :environment => perlbrew_env,
        :cwd         => '/dne',
        :user        => nil,
        :group       => nil,
        :logoutput   => true,
        :unless      => 'which cpanm'
      )
    }
    it { should contain_exec("#{target}_install-cpanm-#{version}").that_requires("Exec[#{target}_install_#{version}]") }

    it { should contain_exec("#{target}_switch_#{version}").with(
        :command     => "perlbrew switch #{version}",
        :path        => perlbrew_path,
        :environment => perlbrew_env,
        :cwd         => '/dne',
        :user        => nil,
        :group       => nil,
        :logoutput   => true,
        :unless      => "grep PERLBREW_PERL=\\\"#{version}\\\" /dne/.perlbrew/init"
      )
    }
    it { should contain_exec("#{target}_switch_#{version}").that_requires("Exec[#{target}_install-cpanm-#{version}]") }
  end # guts

  context 'default params' do
    it_behaves_like 'guts'
  end # default params

  context 'target =>' do
    context 'bar' do
      let(:target) { 'foo' }
      before { params[:target] = target }

      it_behaves_like 'guts'
    end

    context '[]' do
      let(:params) {{ :target => [] }}

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /is not a string/)
      end
    end
  end # target =>

  context 'version =>' do
    context '2.18.5-lrep' do
      let(:version) { '2.18.5-lrep' }
      before { params[:version] = version }

      it_behaves_like 'guts'
    end

    context '[]' do
      before { params[:version] = [] }

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /is not a string/)
      end
    end
  end # version =>

  context 'flags =>' do
    context '--ponies' do
      let(:flags) { '--ponies' }
      before { params[:flags] = flags }

      it_behaves_like 'guts'
    end

    context '[]' do
      before { params[:flags] = [] }

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /is not a string/)
      end
    end
  end # flags =>

  context 'timeout =>' do
    context '42' do
      let(:timeout) { 42 }
      before { params[:timeout] = timeout }

      it_behaves_like 'guts'
    end

    context '[]' do
      before { params[:timeout] = [] }

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /is not a string/)
      end
    end
  end # timeout =>
end

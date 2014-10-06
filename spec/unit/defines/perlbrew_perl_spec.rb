require 'spec_helper'

describe 'perlbrew::perl', :type => :define do
  let(:title) { 'perl-5.18.2' }
  let(:params) {{ :target => 'foo' }}
  let(:pre_condition) { "perlbrew { 'foo': install_root => '/dne' }" }

  context 'default params' do
    it { should contain_exec('foo_install_perl-5.18.2').with(
        :command     => 'perlbrew install perl-5.18.2',
        :cwd         => '/dne',
        :user        => nil,
        :group       => nil,
        :logoutput   => true,
        :creates     => '/dne/perl5/perlbrew/perls/perl-5.18.2'
      )
    }
    it { should contain_exec('foo_switch_perl-5.18.2').with(
        :command     => 'perlbrew switch perl-5.18.2',
        :cwd         => '/dne',
        :user        => nil,
        :group       => nil,
        :logoutput   => true,
        :unless      => "grep PERLBREW_PERL=\\\"perl-5.18.2\\\" /dne/.perlbrew/init"
      )
    }
  end
end

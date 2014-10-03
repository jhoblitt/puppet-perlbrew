require 'spec_helper'

describe 'perlbrew::cpanm', :type => :define do
  let(:title) { 'Module::Build' }
  let(:params) {{ :target => '5.18.2' }}
  let(:pre_condition) do
    <<-eos
      perlbrew { 'foo': install_root => '/dne' }
      perlbrew::perl { '5.18.2': target => 'foo' }
    eos
  end

  context 'default params' do
    it { should contain_exec('5.18.2_cpanm-Module::Build').with(
        :command   => 'cpanm Module::Build',
        :cwd       => '/dne',
        :user      => nil,
        :group     => nil,
        :logoutput => true,
        :unless    => 'perl -MModule::Build -e \'1\'',
      )
    }
  end
end

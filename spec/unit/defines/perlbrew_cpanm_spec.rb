require 'spec_helper'

describe 'perlbrew::cpanm', :type => :define do
  let(:title) { 'Module::Build' }
  let(:params) {{ :target => '5.18.2' }}
  let(:pre_condition) do
    <<-eos
      perlbrew { '/dne': }
      perlbrew::perl { '5.18.2': target => '/dne' }
    eos
  end

  context 'default params' do
    it { should contain_perlbrew__exec('cpanm Module::Build').with(
        :command   => 'cpanm Module::Build',
        :logoutput => true,
        :unless    => 'perl -MModule::Build -e \'1\'',
        :timeout   => 900
      )
    }
  end
end

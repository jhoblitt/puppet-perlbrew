require 'spec_helper'

describe 'perlbrew::cpanm', :type => :define do
  let(:title) { 'Module::Build' }
  let(:params) {{ :target => 'perl-5.18.2' }}
  let(:pre_condition) do
    <<-eos
      perlbrew { '/dne': }
      perlbrew::perl { 'perl-5.18.2': target => '/dne' }
    eos
  end

  context 'title =>' do
    context 'default params' do
      it { should contain_perlbrew__exec('cpanm --notest Module::Build').with(
          :target    => 'perl-5.18.2',
          :path      => ['/bin', '/usr/bin'],
          :logoutput => true,
          :unless    => 'perl -MModule::Build -e \'1\''
        )
      }
    end

    context 'Foo' do
      let(:title) { 'Foo' }

      it { should contain_perlbrew__exec('cpanm --notest Foo').with(
          :target    => 'perl-5.18.2',
          :path      => ['/bin', '/usr/bin'],
          :logoutput => true,
          :unless    => 'perl -MFoo -e \'1\''
        )
      }
    end
  end # title

  context 'module =>' do
    context 'Foo' do
      before { params[:module] = 'Foo' }

      it { should contain_perlbrew__exec('cpanm --notest Foo').with(
          :target    => 'perl-5.18.2',
          :path      => ['/bin', '/usr/bin'],
          :logoutput => true,
          :unless    => 'perl -MFoo -e \'1\''
        )
      }
    end

    context 'false' do
      before { params[:module] = false }

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /is not a string/)
      end
    end
  end # module

  context 'flags =>' do
    context '--batman' do
      before { params[:flags] = '--batman' }

      it { should contain_perlbrew__exec('cpanm --batman Module::Build').with(
          :target    => 'perl-5.18.2',
          :path      => ['/bin', '/usr/bin'],
          :logoutput => true,
          :unless    => 'perl -MModule::Build -e \'1\''
        )
      }
    end

    context 'false' do
      before { params[:flags] = false }

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /is not a string/)
      end
    end
  end # flags

  context 'check_name =>' do
    context 'Bar' do
      before { params[:check_name] = 'Bar' }

      it { should contain_perlbrew__exec('cpanm --notest Module::Build').with(
          :target    => 'perl-5.18.2',
          :path      => ['/bin', '/usr/bin'],
          :logoutput => true,
          :unless    => 'perl -MBar -e \'1\''
        )
      }
    end

    context 'false' do
      before { params[:check_name] = false }

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /is not a string/)
      end
    end
  end # check_name

  context 'timeout =>' do
    context '42' do
      before { params[:timeout] = '42' }

      it { should contain_perlbrew__exec('cpanm --notest Module::Build').with(
          :target    => 'perl-5.18.2',
          :path      => ['/bin', '/usr/bin'],
          :logoutput => true,
          :timeout   => 42,
          :unless    => 'perl -MModule::Build -e \'1\''
        )
      }
    end

    context 'false' do
      before { params[:timeout] = false }

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error, /is not a string/)
      end
    end
  end # timeout
end

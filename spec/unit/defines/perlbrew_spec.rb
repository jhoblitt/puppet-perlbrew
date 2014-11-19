require 'spec_helper'

describe 'perlbrew', :type => :define do
  let(:title) { '/dne' }

  context 'default params' do
    it { should contain_exec('/dne_install_perlbrew').with(
        :command     => 'wget --no-check-certificate -O - http://install.perlbrew.pl | bash',
        :path        => ['/bin', '/usr/bin'],
        :environment => ['HOME=/dne'],
        :cwd         => '/dne',
        :user        => nil,
        :group       => nil,
        :logoutput   => true,
        :creates     => '/dne/perl5/perlbrew/bin/perlbrew'
      )
    }
    it { should_not contain_file('/dne_perlbrew_bashrc') }
    it { should_not contain_file_line('/dne_perlbrew_bashrc') }
  end

  context 'install_root => ' do
    context '/home/baz' do
      let(:params) {{ :install_root => '/home/baz' }}

      it { should contain_exec('/dne_install_perlbrew').with(
          :command     => 'wget --no-check-certificate -O - http://install.perlbrew.pl | bash',
          :path        => ['/bin', '/usr/bin'],
          :environment => ['HOME=/home/baz'],
          :cwd         => '/home/baz',
          :user        => nil,
          :group       => nil,
          :logoutput   => true,
          :creates     => '/home/baz/perl5/perlbrew/bin/perlbrew'
        )
      }
      it { should_not contain_file('/dne_perlbrew_bashrc') }
      it { should_not contain_file_line('/dne_perlbrew_bashrc') }
    end

    context 'home/baz' do
      let(:params) {{ :install_root => 'home/baz' }}
      it 'should fail' do
        should raise_error(Puppet::Error, /is not an absolute path/)
      end
    end
  end # install_root =>

  context 'owner => ' do
    context 'baz' do
      let(:params) {{ :owner => 'baz' }}

      it { should contain_exec('/dne_install_perlbrew').with(
          :cwd   => '/dne',
          :user  => 'baz',
          :group => nil
        )
      }
      it { should_not contain_file('/dne_perlbrew_bashrc') }
      it { should_not contain_file_line('/dne_perlbrew_bashrc') }
    end

    context '[]' do
      let(:params) {{ :owner => [] }}
      it 'should fail' do
        should raise_error(Puppet::Error, /is not a string/)
      end
    end
  end # owner =>

  context 'group => ' do
    context 'baz' do
      let(:params) {{ :group => 'baz' }}

      it { should contain_exec('/dne_install_perlbrew').with(
          :cwd   => '/dne',
          :user  => nil,
          :group => 'baz'
        )
      }
      it { should_not contain_file('/dne_perlbrew_bashrc') }
      it { should_not contain_file_line('/dne_perlbrew_bashrc') }
    end

    context '[]' do
      let(:params) {{ :group => [] }}
      it 'should fail' do
        should raise_error(Puppet::Error, /is not a string/)
      end
    end
  end # group =>

  context 'bashrc => ' do
    context 'true' do
      let(:params) {{ :bashrc => true }}

      it { should contain_exec('/dne_install_perlbrew').with(
          :cwd   => '/dne',
          :user  => nil,
          :group => nil
        )
      }
      it { should contain_file('/dne_perlbrew_bashrc').with(
          :ensure => 'file',
          :path   => '/dne/.bashrc',
          :owner  => nil,
          :group  => nil,
          :mode   => '0644'
        )
      }
      it { should contain_file_line('/dne_perlbrew_bashrc').with(
          :path => '/dne/.bashrc'
        )
      }
    end

    context 'false' do
      let(:params) {{ :bashrc => false }}
      it { should contain_exec('/dne_install_perlbrew').with(
          :cwd   => '/dne',
          :user  => nil,
          :group => nil
        )
      }
      it { should_not contain_file('/dne_perlbrew_bashrc') }
      it { should_not contain_file_line('/dne_perlbrew_bashrc') }
    end

    context '[]' do
      let(:params) {{ :bashrc => [] }}
      it 'should fail' do
        should raise_error(Puppet::Error, /is not a boolean/)
      end
    end
  end # bashrc =>

end

require 'spec_helper'

describe 'hadoop::zookeeper' do
  context 'on Centos 6.5 x86_64' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.5) do |node|
        node.automatic['domain'] = 'example.com'
        stub_command('update-alternatives --display hadoop-conf | grep best | awk \'{print $5}\' | grep /etc/hadoop/conf.chef').and_return(false)
      end.converge(described_recipe)
    end

    it 'install zookeeper package' do
      expect(chef_run).to install_package('zookeeper')
    end
  end
end

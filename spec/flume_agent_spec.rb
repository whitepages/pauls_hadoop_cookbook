require 'spec_helper'

describe 'hadoop::flume_agent' do
  context 'on Centos 6.5 x86_64' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.5) do |node|
        node.automatic['domain'] = 'example.com'
      end.converge(described_recipe)
    end

    it 'does not install flume-agent package' do
      expect(chef_run).not_to install_package('flume-agent')
    end

    it 'runs package-flume-agent ruby_block' do
      expect(chef_run).to run_ruby_block('package-flume-agent')
    end

    it 'creates flume-agent service resource, but does not run it' do
      expect(chef_run).to_not start_service('flume-agent')
    end
  end

  context 'using CDH' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.5) do |node|
        node.automatic['domain'] = 'example.com'
        node.override['hadoop']['distribution'] = 'cdh'
      end.converge(described_recipe)
    end

    it 'does not install flume-ng package' do
      expect(chef_run).not_to install_package('flume-ng-agent')
    end

    it 'runs package-flume-ng-agent ruby_block' do
      expect(chef_run).to run_ruby_block('package-flume-ng-agent')
    end
  end
end

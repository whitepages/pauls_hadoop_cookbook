require 'spec_helper'

describe 'hadoop::avro' do
  context 'on Centos 6.5 x86_64' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.5) do |node|
        node.automatic['domain'] = 'example.com'
      end.converge(described_recipe)
    end

    it 'does not install avro-tools package' do
      expect(chef_run).not_to install_package('avro-tools')
    end
  end

  context 'using CDH 5' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.5) do |node|
        node.override['hadoop']['distribution'] = 'cdh'
        node.override['hadoop']['distribution_version'] = 5
        node.automatic['domain'] = 'example.com'
      end.converge(described_recipe)
    end

    it 'installs avro-tools package' do
      expect(chef_run).to install_package('avro-tools')
    end
  end
end

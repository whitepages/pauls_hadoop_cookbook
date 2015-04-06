require 'spec_helper'

describe 'hadoop::pig' do
  context 'on Centos 6.5 x86_64' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.5) do |node|
        node.automatic['domain'] = 'example.com'
      end.converge(described_recipe)
    end

    it 'install pig package' do
      expect(chef_run).to install_package('pig')
    end
  end
end

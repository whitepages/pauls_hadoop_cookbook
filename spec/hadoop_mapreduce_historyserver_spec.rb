require 'spec_helper'

describe 'hadoop::hadoop_mapreduce_historyserver' do
  context 'on Centos 6.5 x86_64' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.5) do |node|
        node.automatic['domain'] = 'example.com'
        stub_command('update-alternatives --display hadoop-conf | grep best | awk \'{print $5}\' | grep /etc/hadoop/conf.chef').and_return(false)
      end.converge(described_recipe)
    end
    pkg = 'hadoop-mapreduce-historyserver'

    it "does not install #{pkg} package" do
      expect(chef_run).not_to install_package(pkg)
    end

    it "runs package-#{pkg} ruby_block" do
      expect(chef_run).to run_ruby_block("package-#{pkg}")
    end

    it "creates #{pkg} service resource, but does not run it" do
      expect(chef_run).to_not disable_service(pkg)
      expect(chef_run).to_not enable_service(pkg)
      expect(chef_run).to_not reload_service(pkg)
      expect(chef_run).to_not restart_service(pkg)
      expect(chef_run).to_not start_service(pkg)
      expect(chef_run).to_not stop_service(pkg)
    end

    it 'creates mapreduce-jobhistory-intermediate-done-dir execute resource, but does not run it' do
      expect(chef_run).to_not run_execute('mapreduce-jobhistory-intermediate-done-dir').with(user: 'hdfs')
    end

    it 'creates mapreduce-jobhistory-done-dir execute resource, but does not run it' do
      expect(chef_run).to_not run_execute('mapreduce-jobhistory-done-dir').with(user: 'hdfs')
    end
  end
end

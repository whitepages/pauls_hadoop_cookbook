#
# Cookbook Name:: pauls_hadoop
# Recipe:: zookeeper_server
#
# Copyright (C) 2013-2014 Continuuity, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'pauls_hadoop::repo'
include_recipe 'pauls_hadoop::zookeeper'

package 'zookeeper-server' do
  action :install
end

zookeeper_conf_dir = "/etc/zookeeper/#{node['zookeeper']['conf_dir']}"

directory zookeeper_conf_dir do
  mode '0755'
  owner 'root'
  group 'root'
  action :create
  recursive true
end

# Setup zoo.cfg
if node['zookeeper'].key? 'zoocfg'

  # We need to create a data directory, if it exists
  zookeeper_data_dir =
    if node['zookeeper']['zoocfg'].key? 'dataDir'
      node['zookeeper']['zoocfg']['dataDir']
    else
      '/var/lib/zookeeper'
    end
  zookeeper_log_dir =
    if node['zookeeper']['zoocfg'].key? 'dataLogDir'
      node['zookeeper']['zoocfg']['dataLogDir']
    else
      '/var/lib/zookeeper'
    end
  zookeeper_client_port =
    if node['zookeeper']['zoocfg'].key? 'clientPort'
      node['zookeeper']['zoocfg']['clientPort']
    else
      '2181'
    end

  node.default['zookeeper']['zoocfg']['dataDir'] = zookeeper_data_dir
  node.default['zookeeper']['zoocfg']['dataLogDir'] = zookeeper_log_dir
  node.default['zookeeper']['zoocfg']['clientPort'] = zookeeper_client_port
  my_vars = { :properties => node['zookeeper']['zoocfg'] }

  directory zookeeper_data_dir do
    owner 'zookeeper'
    group 'zookeeper'
    mode '0755'
    recursive true
    action :create
  end

  unless zookeeper_log_dir == zookeeper_data_dir
    directory zookeeper_log_dir do
      owner 'zookeeper'
      group 'zookeeper'
      mode '0755'
      recursive true
      action :create
      only_if { node['zookeeper']['zoocfg'].key? 'dataLogDir' }
    end
  end

  template "#{zookeeper_conf_dir}/zoo.cfg" do
    source 'generic.properties.erb'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
    variables my_vars
  end

  # Try and find the current node in the list of configured servers. If the node was found then write the myid file
  myid = nil
  1.upto(255) do |index|
    server = node['zookeeper']['zoocfg']["server.#{index}"]
    unless server.nil?
      if server.start_with?("#{node['fqdn']}:") || server.start_with?("#{node['ipaddress']}:") || server.start_with?("#{node['hostname']}:")
        myid = index
        break
      end
    end
  end

  template "#{node['zookeeper']['zoocfg']['dataDir']}/myid" do
    source 'zookeeper-myid.erb'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
    variables(
      :myid => myid
    )
    not_if { myid.nil? }
  end
end # End zoo.cfg

# Setup log4j.properties
if node['zookeeper'].key? 'log4j'
  my_vars = { :properties => node['zookeeper']['log4j'] }

  template "#{zookeeper_conf_dir}/log4j.properties" do
    source 'generic.properties.erb'
    mode '0644'
    owner 'root'
    group 'root'
    action :create
    variables my_vars
  end
end # End log4j.properties

service 'zookeeper-server' do
  status_command 'service zookeeper-server status'
  supports [:restart => true, :reload => false, :status => true]
  action :nothing
end

# Update alternatives to point to our configuration
execute 'update zookeeper-conf alternatives' do
  command "update-alternatives --install /etc/zookeeper/conf zookeeper-conf /etc/zookeeper/#{node['zookeeper']['conf_dir']} 50"
  not_if "update-alternatives --display zookeeper-conf | grep best | awk '{print $5}' | grep /etc/zookeeper/#{node['zookeeper']['conf_dir']}"
end

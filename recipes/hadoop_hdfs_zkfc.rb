#
# Cookbook Name:: pauls_hadoop
# Recipe:: hadoop_hdfs_zkfc
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

include_recipe 'pauls_hadoop::default'
include_recipe 'pauls_hadoop::hadoop_hdfs_ha_checkconfig'
include_recipe 'pauls_hadoop::zookeeper'

package 'hadoop-hdfs-zkfc' do
  action :install
end

service 'hadoop-hdfs-zkfc' do
  status_command 'service hadoop-hdfs-zkfc status'
  supports [:restart => true, :reload => false, :status => true]
  action :nothing
end

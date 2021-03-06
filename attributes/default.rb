###
# cookbook settings
###
# Supported: cdh, hdp, bigtop
default['hadoop']['distribution'] = 'hdp'

default['hadoop']['force_format'] = false

# Default: conf.chef
default['hadoop']['conf_dir'] = 'conf.chef'
default['flume']['conf_dir'] = node['hadoop']['conf_dir']
default['hbase']['conf_dir'] = node['hadoop']['conf_dir']
default['hive']['conf_dir'] = node['hadoop']['conf_dir']
default['oozie']['conf_dir'] = node['hadoop']['conf_dir']
default['spark']['conf_dir'] = node['hadoop']['conf_dir']
default['tez']['conf_dir'] = node['hadoop']['conf_dir']
default['zookeeper']['conf_dir'] = node['hadoop']['conf_dir']

###
# core-site.xml settings
###
default['hadoop']['core_site']['fs.defaultFS'] = "hdfs://#{node['fqdn']}"

###
# yarn-site.xml settings
###
default['hadoop']['yarn_site']['yarn.resourcemanager.hostname'] = node['fqdn']

default['hadoop']['legacy'] = {
    :download_url => 'http://archive.apache.org/dist/hadoop/core/hadoop-1.2.1/hadoop_1.2.1-1_x86_64.deb',
    :tmp_dir => File.join(Dir.tmpdir, 'hadoop-1.2.1.deb')
}

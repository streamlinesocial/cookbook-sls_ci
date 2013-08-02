# for jenkins nodes, ensure the jenkins attribs are set based on the node data, not attribs
# this ensures the master server can find the node, and labels it as we expect in the jenkins admin
node.set["jenkins"]["node"]["ssh_host"] = node["ipaddress"]
node.set["jenkins"]["node"]["name"] = node["fqdn"]

# setup the ssh private key
jenkins_bag = data_bag_item("users", "jenkins-node")

directory "#{node['jenkins']['node']['home']}/.ssh]" do
    action :nothing
end

file "#{node['jenkins']['node']['home']}/.ssh/id_rsa" do
    content jenkins_bag["private_key"]
    owner node['jenkins']['node']['user']
    group node['jenkins']['node']['user']
    mode '0600'
    action :nothing
    subscribes :create, "directory[#{node['jenkins']['node']['home']}/.ssh]", :immediately
end

file "#{node['jenkins']['node']['home']}/.ssh/id_rsa.pub" do
    content jenkins_bag["public_key"]
    owner node['jenkins']['node']['user']
    group node['jenkins']['node']['user']
    mode '0644'
    action :nothing
    subscribes :create, "directory[#{node['jenkins']['node']['home']}/.ssh]", :immediately
end

# setup the node to enable checkouts from our repos without manual interaction for the first checkout
node["sls_ci"]["known_hosts"].each do |url|
    ssh_known_hosts_entry url
end

#
# taken from the jenkins community cookbook
# here we complete the setup of the user but don't
# add it as a jenkins node automatically, a couple reasons...
# 1. there was a nasty bug that added the ssh node in jenkins credentials for each chef run
# 2. not often for us do we add jenkins nodes, so we can handle this manually via the admin
#
include_recipe "java"

unless Chef::Config[:solo]
  unless node['jenkins']['server']['pubkey']
    host = node['jenkins']['server']['host']
    if host == node['fqdn']
      host = URI.parse(node['jenkins']['server']['url']).host
    end
    jenkins_node = search('node', "fqdn:#{host}").first
    node.set['jenkins']['server']['pubkey'] = jenkins_node['jenkins']['server']['pubkey']
  end
end

group node['jenkins']['node']['group']

user node['jenkins']['node']['user'] do
  comment "Jenkins CI node (ssh)"
  gid node['jenkins']['node']['user']
  home node['jenkins']['node']['home']
  shell node['jenkins']['node']['shell']
end

directory node['jenkins']['node']['home'] do
  owner node['jenkins']['node']['user']
  group node['jenkins']['node']['user']
  action :create
end

directory "#{node['jenkins']['node']['home']}/.ssh" do
  owner node['jenkins']['node']['user']
  group node['jenkins']['node']['user']
  mode '0700'
  action :create
end

file "#{node['jenkins']['node']['home']}/.ssh/authorized_keys" do
  content node['jenkins']['server']['pubkey']
  owner node['jenkins']['node']['user']
  group node['jenkins']['node']['user']
  mode '0600'
  action :create
end

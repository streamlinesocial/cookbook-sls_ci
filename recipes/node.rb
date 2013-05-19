# for jenkins nodes, ensure the jenkins attribs are set based on the node data, not attribs
# this ensures the master server can find the node, and labels it as we expect in the jenkins admin
node.set["jenkins"]["node"]["ssh_host"] = node["ipaddress"]
node.set["jenkins"]["node"]["name"] = node["fqdn"]

# setup the ssh private key
jenkins_bag = data_bag_item("users", "jenkins-node")

file "#{node['jenkins']['node']['home']}/.ssh/id_rsa" do
    content jenkins_bag["private_key"]
    owner node['jenkins']['node']['user']
    group node['jenkins']['node']['user']
    mode '0600'
    action :create
end

file "#{node['jenkins']['node']['home']}/.ssh/id_rsa.pub" do
    content jenkins_bag["public_key"]
    owner node['jenkins']['node']['user']
    group node['jenkins']['node']['user']
    mode '0644'
    action :create
end

# setup the node to enable checkouts from our repos without manual interaction for the first checkout
node["sls_ci"]["known_hosts"].each do |url|
    ssh_known_hosts_entry url
end

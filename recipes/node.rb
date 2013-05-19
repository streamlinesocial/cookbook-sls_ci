# for jenkins nodes, ensure the jenkins attribs are set based on the node data, not attribs
node.set["jenkins"]["node"]["ssh_host"] = node["ipaddress"]
node.set["jenkins"]["node"]["name"] = node["fqdn"]

# setup the ssh private key
jenkins_bag = data_bag_item("users", "jenkins-node")

file "#{node['jenkins']['node']['home']}/.ssh/jenkins-node.rsa" do
    content jenkins_bag["private_key"]
    owner node['jenkins']['node']['user']
    group node['jenkins']['node']['user']
    mode '0600'
    action :create
end

# file "#{node['jenkins']['node']['home']}/.ssh/jenkins-node.rsa.pub" do
#     content jenkins_bag["public_key"]
#     owner node['jenkins']['node']['user']
#     group node['jenkins']['node']['user']
#     mode '0600'
#     action :create
# end

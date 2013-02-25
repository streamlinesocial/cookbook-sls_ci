# for jenkins nodes, ensure the jenkins attribs are set based on the node data, not attribs
node.set["jenkins"]["node"]["ssh_host"] = node["ipaddress"]
node.set["jenkins"]["node"]["name"] = node["fqdn"]

# jenkins_cli "login --username #{node[:jenkins][:server][:username]} --password #{node[:jenkins][:server][:password]}" do

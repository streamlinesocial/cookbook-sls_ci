# add oracle yum repo, note the key is added automatically by yum
# yum_key "ORACLE-VIRTUALBOX-ACS-key" do
#     url "http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc"
#     action :add
# end
remote_file "/etc/yum.repos.d/virtualbox.repo" do
    source "http://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo"
    action :create_if_missing
end

# install virtualbox
package "VirtualBox-4.2" do
    action :install
end

# add vagrant rpm
# yum_repository "vagrant" do
#     repo_name "vagrant"
#     url "http://files.vagrantup.com/packages/476b19a9e5f499b5d0b9d4aba5c0b16ebe434311/vagrant_x86_64.rpm"
#     action :add
# end

# install vagrant as a ruby gem

# add oracle yum repo, note the key is added automatically by yum
# yum_key "ORACLE-VIRTUALBOX-ACS-key" do
#     url "http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc"
#     action :add
# end

# CENTOS TESTED ONLY

# virtualbox
major_minor = "4.3"
min = '20'
version = "#{major_minor}.#{min}"
ext_pack_path = "#{Chef::Config[:file_cache_path]}/Oracle_VM_VirtualBox_Extension_Pack-#{version}.vbox-extpack"

# note: per http://wiki.centos.org/HowTos/Virtualization/VirtualBox possible that
# the Dell version is best, keep RPMForge option in mind
#
# yum groupinstall 'Development Tools' SDL kernel-devel kernel-headers dkms
execute "yum-groupinstall-Base" do
    command "yum groupinstall \"Base\" -y"
    action :nothing

end

execute "yum-groupinstall-Core" do
    command "yum groupinstall \"Core\" -y"
    action :nothing
end

execute "yum-groupinstall-Development-Tools" do
    command "yum groupinstall \"Development Tools\" -y"
    action :nothing
end

package "SDL" do
    action :nothing
end

package "kernel-devel" do
    action :nothing
end

package "kernel-headers" do
    action :nothing
end

package "dkms" do
    action :nothing
end

package "virtualbox" do
    package_name "VirtualBox-#{major_minor}"
    action :nothing
end

execute "virtualbox-install-extension-pack" do
    command "VBoxManage extpack install #{ext_pack_path}"
    action :nothing
end

execute "virtualbox-setup-vboxdrv" do
    command "/etc/init.d/vboxdrv setup"
    action :nothing
end

# cd /etc/yum.repos.d/ && sudo wget http://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo
# sudo wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc
# sudo rpm --import oracle_vbox.asc
remote_file "virtualbox-download-yum-repo" do
    path "/etc/yum.repos.d/virtualbox.repo"
    source "http://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo"
    action :create_if_missing

    notifies :run, "execute[yum-groupinstall-Base]"
    notifies :run, "execute[yum-groupinstall-Core]"
    notifies :run, "execute[yum-groupinstall-Development-Tools]"
    notifies :install, "package[SDL]"
    notifies :install, "package[kernel-devel]"
    notifies :install, "package[kernel-headers]"
    notifies :install, "package[dkms]"
end

# cd /tmp/ &&  wget http://download.virtualbox.org/virtualbox/4.3.12/Oracle_VM_VirtualBox_Extension_Pack-4.3.12-93733.vbox-extpack
remote_file "virtualbox-download-extension-pack" do
    path ext_pack_path
    source "http://download.virtualbox.org/virtualbox/#{version}/Oracle_VM_VirtualBox_Extension_Pack-#{version}.vbox-extpack"
    action :create_if_missing

    notifies :run, "execute[virtualbox-install-extension-pack]", :immediately
    notifies :run, "execute[virtualbox-setup-vboxdrv]", :immediately
end

# so jenkins can use virtualbox
user node['jenkins']['node']['user'] do
    action :manage
    gid "vboxusers"
end

# note: the ls /lib/modules/2.6.32-279.el6.x86_64 -hal showed that there were broken symlinks
# so the fix to get past that was to set KERN_DIR to the proper path (close to where the symlink
# was trying to link to but not quite)
# execute "KERN_DIR=/usr/src/kernels/2.6.32-279.22.1.el6.x86_64 /etc/init.d/vboxdrv setup"

# FAIL - the Rackspace cloud is aparantly a XEN kernel environment, which is unsupported by VirtualBox

# vagrant
vagrant_rpm_path = "#{Chef::Config[:file_cache_path]}/vagrant_1.7.2_x86_64.rpm"

rpm_package "vagrant" do
  action :nothing
  source vagrant_rpm_path
end

remote_file "vagrant-rpm" do
    path vagrant_rpm_path
    source "https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.2_x86_64.rpm"
    action :create_if_missing

    notifies :install, "rpm_package[vagrant]", :immediately
end

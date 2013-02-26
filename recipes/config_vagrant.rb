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

# CENTOS TESTED ONLY

# note: per http://wiki.centos.org/HowTos/Virtualization/VirtualBox possible that
# the Dell version is best, keep RPMForge option in mind
package "dkms"
execute "yum groupinstall \"Base\" -y"
execute "yum groupinstall \"Core\" -y"
execute "yum groupinstall \"Development Tools\" -y"
package "kernel-devel"

# note: the ls /lib/modules/2.6.32-279.el6.x86_64 -hal showed that there were broken symlinks
# so the fix to get past that was to set KERN_DIR to the proper path (close to where the symlink
# was trying to link to but not quite)
execute "KERN_DIR=/usr/src/kernels/2.6.32-279.22.1.el6.x86_64 /etc/init.d/vboxdrv setup"

# FAIL - the Rackspace cloud is aparantly a XEN kernel environment, which is unsupported by VirtualBox

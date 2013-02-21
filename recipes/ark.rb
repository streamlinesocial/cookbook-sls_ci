# wrapper for the ark lib. in centos the package autogen exists only in the epel-testing repo

package "autogen" do
    action :install
    options "--enablerepo=epel-testing"
end

include_recipe "ark"

ruby_version = "ruby-1.9.3"
ruby_gemset = "jenkins"

include_recipe "rvm::system_install"

rvm_environment "#{ruby_version}@#{ruby_gemset}" do
    action :create
    # user node["jenkins"]["node"]["user"]
end

rvm_default_ruby "#{ruby_version}@#{ruby_gemset}" do
    action :create
end

rvm_gem "bundler" do
    action :install
    ruby_string "#{ruby_version}@#{ruby_gemset}"
    # user node["jenkins"]["node"]["user"]
end

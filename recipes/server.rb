# include_recipe "sls_ci::config_php"

# for fonts in the jenkins report image generation
%w{ dejavu-fonts-common
    dejavu-lgc-sans-fonts
    dejavu-lgc-sans-mono-fonts
    dejavu-lgc-serif-fonts
    dejavu-sans-fonts
    dejavu-sans-mono-fonts
    dejavu-serif-fonts
    graphviz-php }.each do |pkg|
    package pkg do
        action :install
    end
end

# default configs for git
cookbook_file "#{node["jenkins"]["server"]["home"]}/hudson.plugins.git.GitSCM.xml" do
    action :create_if_missing
    source "config/hudson.plugins.git.GitSCM.xml"
    owner node["jenkins"]["server"]["user"]
    group node["jenkins"]["server"]["group"]
    mode 00644
end

# add the jenkins php xml
# @see http://jenkins-php.org

# directory "#{node["jenkins"]["server"]["home"]}/jobs" do
#     owner node["jenkins"]["server"]["user"]
#     group node["jenkins"]["server"]["group"]
# end

# %w{php-base php-full}.each do |job_template|
#     directory "#{node["jenkins"]["server"]["home"]}/jobs/#{job_template}" do
#         owner node["jenkins"]["server"]["user"]
#         group node["jenkins"]["server"]["group"]
#     end
#
#     cookbook_file "#{node["jenkins"]["server"]["home"]}/jobs/#{job_template}/config.xml" do
#         action :create
#         source "job-templates/#{job_template}.xml"
#         owner node["jenkins"]["server"]["user"]
#         group node["jenkins"]["server"]["group"]
#         mode 00644
#     end
# end

# reload jenkins config
# java -jar jenkins-cli.jar -s http://localhost:8080 reload-configuration
# jenkins_cli "reload-jenkins-configuration" do
#     command "reload-configuration"
# end


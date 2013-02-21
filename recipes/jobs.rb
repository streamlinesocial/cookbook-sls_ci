directory File.join(node["jenkins"]["server"]["home"], 'templates') do
    action :create
    owner node["jenkins"]["server"]["user"]
    group node["jenkins"]["server"]["group"]
end

data_bag("jenkins_jobs").each do |bag|

    # get the job data
    job = data_bag_item("jenkins_jobs", bag)

    # name job with id and some info about machine it's being built on
    job_name = "#{job["id"]}-#{job["branch"]}-#{node["os"]}-#{node["kernel"]["machine"]}"
    job_dir  = File.join(node["jenkins"]["server"]["home"], 'templates', job_name)
    job_conf = File.join(node["jenkins"]["server"]["home"], 'templates', "#{job_name}-config.xml")

    # build the job
    jenkins_job job_name do
        action :nothing
        config job_conf
    end

    # create template for the job config
    directory job_dir do
        owner node["jenkins"]["server"]["user"]
        group node["jenkins"]["server"]["group"]
    end

    # create template (triggers job build)
    template job_conf do
        source "job_config/#{job["job-template"]}.xml.erb"
        owner node["jenkins"]["server"]["user"]
        group node["jenkins"]["server"]["group"]
        variables({
            :name         => job_name,
            :id           => job["id"],
            :description  => "#{job["description"]}",
            :repository   => job["repository"],
            :branch       => job["branch"],
            :node         => node["fqdn"]
        })
        # notify the parent job of the change (reloads jenkins)
        # notifies :restart, "service[jenkins]"
        notifies :update, resources(:jenkins_job => job_name), :immediately
        notifies :build, resources(:jenkins_job => job_name), :immediately
    end
end

Configures server/nodes for jenkins ci server.

Recipes
=======

### sls\_ci::server

Configures the server node. Requires the attribute node["jenkins"]["server"]["plugins"] to be set and a valid array.

Templates
=========

### default/jobs/\*.xml.erb

These jobs are initial builds, not meant to be long-maintained builds, but initial builds only to be used as bases for other projects.

    # create template for the job config
    template job_config do
        source "job_config/#{job["job-template"]}.xml.erb"
        variables({
            :name         => job_name,
            :id           => job["id"],
            :description  => job["description"],
            :branch       => job["repository"],
            :node         => node["fqdn"]
        })
        # notify the parent job of the change (reloads jenkins)
        notifies :update, resources(:jenkins_job => job_name), :immediately
        notifies :build, resources(:jenkins_job => job_name), :immediately
    end

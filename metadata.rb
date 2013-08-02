maintainer        "Chris Buryta"
maintainer_email  "chris@buryta.com"
license           "Apache 2.0"
description       "Configures Streamline Social CI Server"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.3.0"

recipe            "sls_ci", "Empty"
recipe            "sls_ci::server", "Main configuration for Jenkins server"
recipe            "sls_ci::config_php", "Setup an env for testing php apps"
recipe            "sls_ci::config_vagrant", "Setup an env for testing vagrant builds"
recipe            "sls_ci::jobs", "Manage jobs on the Jenkins server"
recipe            "sls_ci::ark", "Utility script to install ark reliably on CentOS 6 using the epel-testing repo"
recipe            "sls_ci::node", "For build nodes, set settings or other pre-config values (like use the ip to access the node not the fqdn)"

depends "ark"
depends "ant"
depends "jenkins"
depends "ssh_known_hosts"
depends "partial_search"
depends "rvm"
depends "java"
suggests "php"
suggests "composer"

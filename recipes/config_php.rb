# @todo: this would be an awesome resource that was attribute configurable

# define pear channels, and their packages / versions (optionally) to install
pear_pkgs = {
    "pear.php.net"          => {
        "XML_Parser2"               => "0.1.0",
        "Text_Highlighter"          => "0.7.3",
        "PHP_CodeSniffer"           => nil
    },
    "pear.phpunit.de"       => {
        "PHPUnit"                   => nil,
        "PHPUnit_SkeletonGenerator" => nil,
        "phpcpd"                    => nil,
        "phploc"                    => nil
    },
    "pear.phpdoc.org"       => {},
    "pear.phpmd.org"        => {
        "PHP_PMD"                   => nil
    },
    "pear.pdepend.org"      => {
        "PHP_Depend"                => nil
    },
    "pear.phpqatools.org"   => {
        "PHP_CodeBrowser"           => nil
    },
    "pear.nette.org"        => {},
    "pear.texy.info"        => {},
    "pear.kukulich.cz"      => {},
    "pear.andrewsville.cz"  => {},
    "pear.apigen.org"       => {
        "ApiGen"                    => nil
    }
}

# setup pear and the required channels
execute "pear-enable-auto-discover" do
    command "pear config-set auto_discover 1"
end

# only install if we don't have the required commands,
# speeds up pear installs in chef run

pear_pkgs.each do |channel_name, pkgs|
    # discover the channel
    pear_channel = php_pear_channel channel_name do
      action :discover
    end
    # using this channel, install the packages
    pkgs.each do |pkg_name,pkg_version|
        php_pear pkg_name do
            version pkg_version
            channel pear_channel.channel_name
            action :install
        end
    end
end

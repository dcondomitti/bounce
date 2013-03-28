class Configuration
  class << self
    def chef_server_url
      ENV['CHEF_SERVER_URL']  or raise StandardError.new('You must specify a chef server URL (CHEF_SERVER_URL)')
    end

    def chef_client_name
      ENV['CHEF_CLIENT_NAME'] or raise StandardError.new('You must specify a chef client name (CHEF_CLIENT_NAME)')
    end

    def chef_client_key
      ENV['CHEF_CLIENT_KEY'] or raise StandardError.new('You must specify a chef client key (CHEF_CLIENT_KEY)')
    end

    def chef_version
      ENV['CHEF_VERSION'] || '10.16.2'
    end

    def chef_user_agent
      ENV['CHEF_USER_AGENT'] || 'Spice'
    end
  end
end

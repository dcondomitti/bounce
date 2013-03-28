APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

require 'rubygems'
require 'sinatra'
require 'haml'
require 'spice'

require_relative 'configuration'

$spice = Spice::Connection.new({
          server_url:   Configuration.chef_server_url,
          client_name:  Configuration.chef_client_name,
          client_key:   Configuration.chef_client_key,
          chef_version: Configuration.chef_version,
          user_agent:   Configuration.chef_user_agent
        })

class Bounce < Sinatra::Application

  configure do
    set :root, APP_ROOT
    set :public_folder, Proc.new { File.join(root, "static") }
  end

  before do

  end

  get '/' do
    haml :index
  end

end


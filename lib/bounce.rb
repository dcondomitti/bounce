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
    @balancers = balancers
    @nodes = nodes
    haml :index
  end

  def balancers(opts = {})
    search(:cluster_name => opts.fetch(:cluster_name, false), :roles => [:balancer])
  end

  def nodes(opts = {})
    search(:cluster_name => opts.fetch(:cluster_name, false), :roles => [:cluster_nodes, :standalone_nodes])
  end

  def search(opts = {})
    node_query = query = []

    cluster_name = opts.fetch(:cluster_name, false)
    if cluster_name
      query << "(elasticsearch_cluster_name:#{cluster_name})" 
    end

    node_type = opts.fetch(:roles, [])

    if node_type.empty?
      node_query << "(role:elasticsearch-*)"
    else
      node_query << "(role:elasticsearch-balancer)" if node_type.include? :balancer
      node_query << "(role:elasticsearch-cluster)" if node_type.include? :cluster_nodes
      node_query << "(role:elasticsearch-standalone)" if node_type.include? :standalone_nodes
    end

    if node_query.count == 1
      query << node_query
    else
      query << "(#{node_query.join(' WAT ')})"
    end
    
    $spice.get('/search/nodes', :q => query)
  end
end

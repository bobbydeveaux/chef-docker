#! /usr/bin/env/ruby
# Deploy a web server, two app servers, and a load balancer
require 'chef/provisioning/docker_driver'

# Setup the global variables
chef_env  = '_default'
domain    = 'demoapp.local'
subdomain = "#{chef_env}.#{domain}"

# Define the instance count
num_appservers = 2
num_webservers = 1

# Conditional deployment
if chef_env.eql?("production")
  num_appservers = 10
  num_webservers = 5
end

# Web Servers
1.upto(num_webservers) do |i|
  machine "web#{i}.#{domain}" do
    recipe 'apt::default' # Update local apt database
    recipe 'nginx'        # running on port 80, using Go on port 3000
    chef_environment chef_env
      machine_options :docker_options => {
        :base_image => {
          :name => 'ubuntu',
          :repository => 'ubuntu',
          :tag => '14.04'
        },
        :command => 'service nginx start'
      }
  end
end

# Launch Application servers in parallel
machine_batch do
  1.upto(num_appservers) do |i|
    machine "app#{i}.#{domain}" do
      recipe 'apt::default' # Update local apt database
      recipe 'golang'       #running on port 3000
      chef_environment chef_env
      machine_options :docker_options => {
        :base_image => {
        :name => 'ubuntu',
        :repository => 'ubuntu',
        :tag => '14.04'
        },
        :command => ''
      }
    end
  end
end

# Load balancer
machine "lb1.#{domain}" do
  recipe 'haproxy'
  chef_environment chef_env
  machine_options :docker_options => {
      :base_image => {
      :name => 'ubuntu',
      :repository => 'ubuntu',
      :tag => '14.04'
    },
    :command => 'service haproxy start'
  }
end
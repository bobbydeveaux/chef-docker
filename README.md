# Docker / Chef example using chef-provisioning-docker

The purpose of this is to demonstrate spinning up a few Docker containers using Chef. 

## Requirements

* Download & install Docker
* Download & install ChefDK (includes Chef-Zero for local server)

## Next Steps

Install chef-provisioning-docker library NOTE: Requires latest beta version to comply with new Docker Toolkit

```chef gem install chef-provisioning-docker --version 1.0.0.beta.1```

### Cookbooks Required

echo "cookbook_path = '~/code/chef-docker/cookbooks'" >> ~/code/chef-docker/.chef/knife.rb
mkdir -p ~/code/chef-docker/cookbooks
cd ~/code/chef-docker/cookbooks && git init
echo '# Cookbooks repository for chef-local' > README.md
git add *; git commit -am 'Added README'
 
knife cookbook site install apt -z
knife cookbook site install haproxy -z
knife cookbook site install nginx -z
knife cookbook site install go -z


## Lets go!

```CHEF_DRIVER=docker chef-client -z environment-setup.rb```

Point your browser to http://localhost:8080 and you should see:

Hi there, I'm served from app1.demoapp.local
and
Hi there, I'm served from app2.demoapp.local

In a round-robin fashion.
require 'lib/cap_recipies'

set :application, "floatingbill"
set :deploy_to, "/srv/web/#{application}"
server "78.46.83.243", :app, :web, :db, :primary => true
set :user, "deployer"
set :use_sudo, false
ssh_options[:port] = 25555
ssh_options[:forward_agent] = true

#############################################################
#	GIT
#############################################################

set :scm, :git
set :repository, "git@github.com:mino/floatingbill.git"
set :branch, "master"
set :deploy_via, :remote_cache


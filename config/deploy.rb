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

#############################################################
#	Passenger
#############################################################

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
 
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end

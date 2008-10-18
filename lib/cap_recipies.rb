Capistrano::Configuration.instance(:must_exist).load do

  #############################################################
  #	Database.yml
  #############################################################

  desc "Link to the real database.yml"
  task :link_database, :role => :app do
    run "link /srv/web/floatingbill/database.yml /srv/web/floatingbill/current/config/database.yml"
  end

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

end


Capistrano::Configuration.instance(:must_exist).load do

  namespace :deploy do
    #############################################################
    #	Passenger
    #############################################################

    desc "Restarting mod_rails with restart.txt"
    task :restart, :roles => :app, :except => { :no_release => true } do
      run "touch #{current_path}/tmp/restart.txt"
    end

    [:start, :stop].each do |t|
      desc "#{t} task is a no-op with mod_rails"
      task t, :roles => :app do ; end
    end

    #############################################################
    #	Database.yml
    #############################################################

    desc "Link to the real database.yml"
    task :link_database, :role => :app do
      run "link #{shared_path}/config/database.yml #{current_path}/config/database.yml"
    end
  end

  #############################################################
  #	BackgrounDRb
  #############################################################
  namespace :brb do

    desc "start BackgrounDRb"
    task :start, :role => :app do
      run "#{current_path}/script/backgroundrb start -e production"
    end

    desc "stop BackgrounDRb"
    task :stop, :role => :app do
      run "#{current_path}/script/backgroundrb stop -e production"
    end
  end

after 'deploy:symlink', 'deploy:link_database'
#before 'deploy:restart', 'brb:stop'
after 'deploy:restart', 'brb:start'

end

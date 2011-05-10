#----------------------------------------
#
#Memo: install rmagick for attachment_fu to resize image
#sudo apt-get install imagemagick
#sudo apt-get install libmagick9-dev
#sudo gem install rmagick
#http://github.com/dalibor/ubuntu_ror_installation
#
#----------------------------------------
set :application, 'outcircle'
set :web_domain, 'outcircle.com'
set :stack, :passenger_nginx
set :rails_env, 'production'

set :user, 'root'
set :hosting, 'webbynode'
set :deploy_to, "/var/rails/deploy"
role :web, 'outcircle.com'
role :app, 'outcircle.com'
role :db, 'outcircle.com', :primary => true

default_run_options[:pty] = true

set :repository,  "git@github.com:ilake/exview.git"
set :scm, "git"
set :git_account, 'ilake'
set :scm_passphrase, "plokmiju" #This is your custom users password

set :branch, "master"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :git_enable_submodules, 1
set :use_sudo, false

after "deploy", "deploy:cleanup"
after "deploy:setup", "deploy:share_folder_setup"
after "deploy:update_code", "deploy:upload_settings"
after "deploy:update_code", "deploy:chown"

namespace :deploy do

  desc "initialize project (just run on the first time , this project install)"
  task :init_prj do
    install_default_package
    db_seed
  end

  desc "Install default system package"
  task :install_default_package, :roles => :app  do
    sudo "apt-get -y install imagemagick"
  end

  desc "Run rake db:seed on production machine"
  task :db_seed, :roles => :app  do
    run "cd #{current_path}; rake RAILS_ENV=#{rails_env} db:seed"
  end

  desc "Create the app-specific folders in shared"
  task :share_folder_setup, :roles => :app do
    run "cd #{shared_path}; if [ ! -d 'config' ]; then mkdir -p config; fi;"
    run "cd #{shared_path}; if [ ! -d 'tmp/pids' ]; then mkdir -p tmp/pids; fi;"
    run "cd #{shared_path}; if [ ! -d 'tmp/sockets' ]; then mkdir -p tmp/sockets; fi;"
  end

  desc "Upload the specific setting file"
  task :upload_settings, :roles => :app do
    %w(app_config.yml database.yml).each do |file|
      upload_file(file)
    end
  end

  desc "Change the project owner"
  task :chown, :roles => :app do
    run "cd #{shared_path} && chown www-data #{shared_path} -R;"
    run "cd #{latest_release} && chown www-data #{latest_release} -R;"
  end

  desc "Reupload the specific setting file"
  task :reupload_settings, :roles => :app do
    %w(app_config.yml database.yml).each do |file|
      sudo "rm #{shared_path}/config/#{file} #{current_release}/config/#{file}"
      upload_file(file)
    end
  end

  task :restart, :roles => :app do
    delayed_job::stop
    run "touch #{current_path}/tmp/restart.txt"
    delayed_job::start
  end

end


after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"

namespace :delayed_job do
  desc "Start delayed_job process"
  task :start, :roles => :app do
    run "cd #{current_path}; ruby script/delayed_job start -- #{rails_env}"
  end

  desc "Stop delayed_job process"
  task :stop, :roles => :app do
    run "cd #{current_path}; script/delayed_job stop -- #{rails_env}"
  end

  desc "Restart the delayed_job process"
  task :restart, :roles => :app do
    stop
    wait_for_process_to_end("delayed_job")
    start
  end
end

after "deploy:symlink", "whenever:update_crontab"
namespace :whenever do
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{current_path} && bundle exec whenever --update-crontab #{application}"
  end
end

def wait_for_process_to_end(process_name)
  run "COUNT=1; until [ $COUNT -eq 0 ]; do COUNT=`ps -ef | grep -v 'ps -ef' | grep -v 'grep' | grep -i '#{process_name}'|wc -l` ; echo 'waiting for #{process_name} to end' ; sleep 2 ; done"
end

def upload_file(file)
  system "scp config/#{file} #{user}@#{web_domain}:#{deploy_to}/shared/config/ "
  sudo "ln -s #{shared_path}/config/#{file} #{current_release}/config/#{file}" # create a symlink to curren
end

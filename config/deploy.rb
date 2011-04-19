# This is a sample Capistrano config file for rubber

set :rails_env, RUBBER_ENV

on :load do
  set :application, rubber_env.app_name
  set :runner,      rubber_env.app_user
  set :deploy_to,   "/mnt/#{application}-#{RUBBER_ENV}"
  set :copy_exclude, [".git/*", ".bundle/*", "log/*"]
end

ssh_options[:forward_agent] = true
set :repository, "git@github.com:ilake/exview.git"
set :scm, "git"
set :deploy_via, :remote_cache
set :branch, 'ec2'



# Use a simple directory tree copy here to make demo easier.
# You probably want to use your own repository for a real app
#set :scm, :none
#set :repository, "."
#set :deploy_via, :copy

# Easier to do system level config as root - probably should do it through
# sudo in the future.  We use ssh keys for access, so no passwd needed
set :user, 'root'
set :password, nil

# Use sudo with user rails for cap deploy:[stop|start|restart]
# This way exposed services (mongrel) aren't running as a privileged user
set :use_sudo, true

# How many old releases should be kept around when running "cleanup" task
set :keep_releases, 3

# Lets us work with staging instances without having to checkin config files
# (instance*.yml + rubber*.yml) for a deploy.  This gives us the
# convenience of not having to checkin files for staging, as well as
# the safety of forcing it to be checked in for production.
set :push_instance_config, RUBBER_ENV != 'production'

# Allows the tasks defined to fail gracefully if there are no hosts for them.
# Comment out or use "required_task" for default cap behavior of a hard failure
rubber.allow_optional_tasks(self)
# Wrap tasks in the deploy namespace that have roles so that we can use FILTER
# with something like a deploy:cold which tries to run deploy:migrate but can't
# because we filtered out the :db role
namespace :deploy do
  rubber.allow_optional_tasks(self)
  tasks.values.each do |t|
    if t.options[:roles]
      task t.name, t.options, &t.body
    end
  end
end

# load in the deploy scripts installed by vulcanize for each rubber module
Dir["#{File.dirname(__FILE__)}/rubber/deploy-*.rb"].each do |deploy_file|
  load deploy_file
end

after "deploy", "deploy:cleanup"

after "deploy:setup", "share_folder_setup"
after "deploy:update_code", "upload_settings"

desc "Create the app-specific folders in shared"
task :share_folder_setup, :roles => :app do
  run "cd #{shared_path}; if [ ! -d 'config' ]; then mkdir -p config; fi;"
  run "cd #{shared_path}; if [ ! -d 'tmp/pids' ]; then mkdir -p tmp/pids; fi;"
  run "cd #{shared_path}; if [ ! -d 'tmp/sockets' ]; then mkdir -p tmp/sockets; fi;"
end

desc "Upload the specific setting file"
task :upload_settings, :roles => :app do
  %w(app_config.yml).each do |file|
    system "scp -i #{rubber_env.cloud_providers.aws.key_file} config/#{file} #{rubber_env.app_user}@#{rails_env}.#{rubber_env.domain}:#{deploy_to}/shared/config/ "
    run "ln -s #{shared_path}/config/#{file} #{current_release}/config/#{file}" # create a symlink to curren
  end
end

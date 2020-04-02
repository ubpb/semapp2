lock "~> 3.9"

set :application, "semapp"
set :repo_url, 'git@github.com:ubpb/semapp2.git'
set :branch,   'master'
set :log_level,   :debug

set :linked_files, fetch(:linked_files, []).push(
  "config/database.yml", "config/sem_app.yml", "config/secrets.yml", "config/newrelic.yml"
)
set :linked_dirs, fetch(:linked_dirs, []).push(
  "log", "tmp", "data", "public/assets"
)

set :rvm_type, :user
set :rvm_ruby_version, IO.read(".ruby-version").strip

set :rails_env, "production"

namespace :deploy do
  after :publishing, :app, :restart
end

def ask_and_fetch(thing, default_value = nil)
  ask(thing, default_value)
  fetch(thing)
end

namespace :app do
  desc 'Restart the app'
  task :restart do
    on roles(:web), in: :parallel do
      within release_path do
        execute :touch, "tmp/restart.txt"
      end
    end
  end

  namespace :maintenance do
    desc 'Activate maintenance mode'
    task :on do
      on roles(:web), in: :parallel do |host|
        within release_path do
          execute :touch, "public/MAINTENANCE_ON"
        end
      end
    end

    desc 'Deactivate maintenance mode'
    task :off do
      on roles(:web), in: :parallel do |host|
        within release_path do
          execute :rm, "public/MAINTENANCE_ON"
        end
      end
    end
  end

  namespace :db do
    desc 'Pull db from remote server'
    task :pull do
      # Find the first server in role 'db' (all db servers read the same database)
      server = Capistrano::Configuration.env.send(:servers).find{ |s| s.roles.include?(:db) }
      raise "No proper server found" if server.nil?

      # Setup variables
      dump_file_name = "semapp-#{Time.now.strftime("%Y%m%d-%H%M%S")}.sql"
      dump_file = "/tmp/#{dump_file_name}"

      remote_db   = ask_and_fetch(:remote_db)
      remote_user = ask_and_fetch(:remote_user)
      remote_pw   = ask_and_fetch(:remote_pw)
      local_db    = ask_and_fetch(:local_db, "semapp2_development")
      local_user  = ask_and_fetch(:local_user, "root")
      local_pw    = ask_and_fetch(:local_pw)

      # Dump db on remote server
      on(server) do |host|
        if remote_pw
          execute("mysqldump -h mysqlmaster -u #{remote_user} -p#{remote_pw} #{remote_db} > #{dump_file}")
        else
          execute("mysqldump -h mysqlmaster -u #{remote_user} #{remote_db} > #{dump_file}")
        end
      end

      # Download file
      on(server) do |host|
        download!(dump_file, dump_file)
      end

      # Restore dump locally
      if local_pw
        system("mysql -h localhost -u #{local_user} -p#{local_pw} #{local_db} < #{dump_file}")
      else
        system("mysql -h localhost -u #{local_user} #{local_db} < #{dump_file}")
      end

      # Delete dump on remote server
      on(server) do |host|
        execute("rm #{dump_file}")
      end

      # Delete dump locally
      system("rm #{dump_file}")
    end
  end
end

lock "~> 3.9"

set :application, "semapp"
set :repo_url, 'git@github.com:ubpb/semapp2.git'
set :branch,   'master'
set :log_level,   :debug

set :linked_files, fetch(:linked_files, []).push(
  "config/database.yml", "config/sem_app.yml", "config/master.key", "config/newrelic.yml"
)
set :linked_dirs, fetch(:linked_dirs, []).push(
  "log", "tmp", "data", "public/assets"
)

set :rvm_type, :user
set :rvm_ruby_version, IO.read(".ruby-version").strip

set :rails_env, "production"

namespace :deploy do
  after :publishing, "app:restart"
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
    desc "Pull db from remote server and install locally"
    task :pull do
      # Find the first server in role 'db' (all db servers read the same database)
      server = Capistrano::Configuration.env.send(:servers).find{ |s| s.roles.include?(:db) }
      raise "No server in role 'db' found" if server.nil?

      # Setup variables
      dump_file_name   = "#{fetch(:application)}-#{Time.now.strftime("%Y%m%d-%H%M%S")}.dump"
      remote_dump_file = "/tmp/#{dump_file_name}"
      local_dump_file  = "/tmp/#{dump_file_name}"

      # Dump db on remote server
      on(server) do |host|
        db_config = YAML.load(capture("cat #{shared_path}/config/database.yml"), aliases: true)[fetch(:rails_env)]

        host     = db_config["host"]
        database = db_config["database"]
        username = db_config["username"]
        password = db_config["password"]

        execute("mysqldump --column-statistics=0 -h #{host} -u #{username} -p#{password} -r #{remote_dump_file} #{database}")
      end

      # Download file
      on(server) do |host|
        download!(remote_dump_file, local_dump_file)
      end

      # Restore dump locally
      run_locally do
        db_config = YAML.load(capture(:cat, "config/database.yml"), aliases: true)["development"]

        host     = db_config["host"] || "localhost"
        database = db_config["database"]
        username = db_config["username"]
        password = db_config["password"]

        username_param = username ? "-u #{username}" : ""
        password_param = password ? "-p #{password}" : ""

        execute("mysql -h #{host} #{username_param} #{password_param} -e \"DROP DATABASE IF EXISTS #{database}\"")
        execute("mysql -h #{host} #{username_param} #{password_param} -e \"CREATE DATABASE #{database}\"")
        execute("mysql -h #{host} #{username_param} #{password_param} #{database} < #{local_dump_file}")
      end

      # Delete dump on remote server
      on(server) do |host|
        execute("rm #{remote_dump_file}")
      end

      # Delete dump locally
      run_locally do
        execute("rm #{local_dump_file}")
      end
    end
  end
end

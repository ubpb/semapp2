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
  after :publishing, :restart_app do
    on roles(:web) do
      within release_path do
        execute :touch, "tmp/restart.txt"
      end
    end
  end
end

namespace :app do
  namespace :db do
    desc 'Pull db from remote server'
    task :pull do
      # Find the first server in role 'db' (all db servers read the same database)
      server = Capistrano::Configuration.env.send(:servers).find{ |s| s.roles.include?(:db) }
      raise "No proper server found" if server.nil?

      # Setup variables
      dump_file_name = "semapp-#{Time.now.strftime("%Y%m%d-%H%M%S")}.dump"
      remote_db = "semapp"
      local_db = "semapp2"
      remote_dump_file = "/tmp/#{dump_file_name}"
      local_dump_file = "/tmp/#{dump_file_name}"

      # Dump db on remote server
      on(server) do |host|
        execute("export PGPASSWORD=#{ENV['REMOTE_DB_PASSWORD']} ; pg_dump -x -O -F c -f #{remote_dump_file} -U postgres #{remote_db}")
      end

      # Download file
      on(server) do |host|
        download!(remote_dump_file, local_dump_file)
      end

      # Restore dump locally
      system("pg_restore -x -O -c -d #{local_db} #{local_dump_file}")

      # Delete dump on remote server
      on(server) do |host|
        execute("rm #{remote_dump_file}")
      end

      # Delete dump locally
      system("rm #{local_dump_file}")
    end
  end
end

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

set :rvm_type,         :user
set :rvm_ruby_version, "default"

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

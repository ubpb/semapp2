set :application, 'semapp'
set :deploy_to,   '/semapp'

set :scm,      :git
set :repo_url, 'git@github.com:ubpb/semapp2.git'
set :branch,   'master'

set :rails_env,    'production'
set :format,       :pretty
set :pty,          true
set :log_level,    :info
set :keep_releases, 5

set :rvm_ruby_version, 'ruby-2.0.0-p353'
set :rvm_type,         :system

set :linked_files, %w{config/database.yml}
set :linked_dirs,  %w{log tmp data}

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :rake, 'cache:clear'
      end
    end
  end

  after :finishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end

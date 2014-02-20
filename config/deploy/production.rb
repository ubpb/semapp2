set :branch, 'production'
server 'ubsemapp', user: 'ubpb', roles: [:web, :app, :db]

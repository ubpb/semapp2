server "ubpegasus18", user: "ubpb", roles: %w{app web db}
server "ubperseus18", user: "ubpb", roles: %w{app web}
set :deploy_to, "/ubpb/semapp2"
set :branch, "pg2mysql"

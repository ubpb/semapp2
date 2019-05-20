server "ubpegasus18", user: "ubpb", roles: %w{app web db}
server "ubperseus18", user: "ubpb", roles: %w{app web}
set :deploy_to, "/ubpb/semapp"
set :branch, "pg2mysql"

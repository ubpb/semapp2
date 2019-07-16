server "ubpegasus18", user: "ubpb", roles: %w{app web}
server "ubperseus18", user: "ubpb", roles: %w{app web}
server "ubatch18",    user: "ubpb", roles: %w{app db}
set :deploy_to, "/ubpb/semapp"
set :branch, "production"

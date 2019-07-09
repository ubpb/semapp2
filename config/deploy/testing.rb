server "ubstage18", user: "ubpb", roles: %w{app db web}
set :deploy_to, "/ubpb/semapp"
set :branch, "pg2mysql"

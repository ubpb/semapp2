server "stage.ub.upb.de", user: "ubpb", roles: %w{app db web}
set :deploy_to, "/ubpb/semapp"
set :branch, "master"

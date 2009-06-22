begin
  require 'highline/import'
rescue LoadError
  puts 'Please install the highline gem.'
end

namespace :app do

  #
  # Inits an new installtion. Required after installation.
  #
  desc "inits a new installation"
  task(:init => :environment) do
    # Create default user authorities
    Authority.new(:name => 'ROLE_ADMIN').save!
  end

  #
  # Creates a new admin user
  #
  desc "creates an admin user"
  task(:create_admin => :environment) do
    admin_login = ask("Admin Login? (e.g. 'admin')")
    password    = ask("Admin Password?")
    email       = ask("Admin E-Mail?")

    u = User.new(:login => admin_login, :email => email)
    u.set_password(password)
    u.save!
    u.authorities << Authority.find_by_name('ROLE_ADMIN')

    say "Admin account created."
  end

end

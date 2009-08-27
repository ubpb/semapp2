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
  task(:init => [:load_authorities, :create_user])

  #
  # Loads the default authorities
  #
  desc "loads authorities into the database"
  task(:load_authorities => :environment) do
    # Create default user authorities
    Authority.new(:name => 'ROLE_ADMIN').save!
  end

  #
  # Creates a new user
  #
  desc "creates a new user"
  task(:create_user => :environment) do
    admin_login = ask("Login?")
    password    = ask("Password?")
    email       = ask("E-Mail?")
    firstname   = ask("First name?")
    lastname    = ask("Last name?")
    is_admin    = agree("Admin?")

    u = User.new(
      :login => admin_login,
      :email => email,
      :firstname => firstname,
      :lastname => lastname, 
      :active => true,
      :approved => true)
    u.set_password(password)
    u.save!

    if (is_admin)
      u.authorities << Authority.find_by_name('ROLE_ADMIN')
    end

    say "Account created and activated."
  end

  #
  # Runs the book sync
  #
  desc "syncs the books"
  task(:sync_books => :environment) do
    connector = AlpehXserverConnector.new # TODO: make this configurable
    engine    = BookSyncEngine.new(connector)
    engine.sync
  end

  #
  # Dummydata
  #
  namespace :dummydata do
    desc "creates dummy data to play with"
    task(:create => [:create_semesters, :create_locations, :create_semapps])

    desc "creates semesters"
    task(:create_semesters => :environment) do
      Semester.new(:title => "Testsemester XXX").save!
    end

    desc "creates locations"
    task(:create_locations => :environment) do
      Location.new(:title => "Testabteilung XXX").save!
    end

    desc "creates 100 sem apps"
    task(:create_semapps => :environment) do
      semester = Semester.find(:first)
      location = Location.find(:first)

      100.times do |i|
        s               = SemApp.new
        s.title         = "SemApp #{i}"
        s.active        = true
        s.approved      = true
        s.semester      = semester
        s.location      = location
        s.tutors        = "Prof. Dr. John Doe, Max Mustermann"
        s.shared_secret = "12345"
        if s.valid?
          s.save!
        else
          puts "SemApp #{i} is not valid:"
          s.errors.each {|attr,msg| puts "\t#{attr} - #{msg}"}
        end
      end
    end
  end

end

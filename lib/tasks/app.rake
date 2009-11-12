begin
  require 'highline/import'
rescue LoadError
  puts '######################################'
  puts '# Please install the highline gem.   #'
  puts '# $sudo gem install highline         #'
  puts '######################################'
end

namespace :app do

  #
  # Create a new user
  #
  desc "Create a new user"
  task(:create_user => :environment) do
    admin_login = ask("Login?")
    password    = ask("Password?")
    email       = ask("E-Mail?")
    firstname   = ask("First name?")
    lastname    = ask("Last name?")
    is_admin    = agree("Admin?")

    User.transaction do
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
        admin_role = Authority.find_by_name(Authority::ADMIN_ROLE)
        u.authorities << admin_role if admin_role
      end
    end

    say "Account created and activated."
  end

  #
  # Synchronize books
  #
  desc "Synchronize books"
  task(:sync_books => :environment) do
    connector = AlpehXserverConnector.new # TODO: make this configurable
    engine    = BookSyncEngine.new(connector)
    engine.sync
  end

  #
  # Creates a new semester
  #
  desc "creates a new semester"
  task(:create_semester => :environment) do
    options  = {}
    options[:title]    = ask("Titel")
    options[:current]  = agree("Ist dies das aktuelle Semester?")
    options[:position] = ask("Sortierung 0-n")
    
    s = Semester.new(options)
    if s.valid?
      s.save!
    else
      puts "Semester #{s} is not valid:"
      s.errors.each {|attr,msg| puts "\t#{attr} - #{msg}"}
    end
  end

  #
  # Creates a new location
  #
  desc "creates a new location"
  task(:create_location => :environment) do
    options  = {}
    options[:title]    = ask("Titel")
    options[:position] = ask("Sortierung 0-n")

    s = Location.new(options)
    if s.valid?
      s.save!
    else
      puts "Location #{s} is not valid:"
      s.errors.each {|attr,msg| puts "\t#{attr} - #{msg}"}
    end
  end

  #
  # Dummydata
  #
  #  namespace :dummydata do
  #    desc "creates dummy data to play with"
  #    task(:create => [:create_semesters, :create_locations, :create_semapps])
  #
  #    desc "creates semesters"
  #    task(:create_semesters => :environment) do
  #      Semester.new(:title => "Testsemester XXX").save!
  #    end
  #
  #    desc "creates locations"
  #    task(:create_locations => :environment) do
  #      Location.new(:title => "Testabteilung XXX").save!
  #    end
  #
  #    desc "creates 100 sem apps"
  #    task(:create_semapps => :environment) do
  #      semester = Semester.find(:first)
  #      location = Location.find(:first)
  #
  #      100.times do |i|
  #        s               = SemApp.new
  #        s.title         = "SemApp #{i}"
  #        s.active        = true
  #        s.approved      = true
  #        s.semester      = semester
  #        s.location      = location
  #        s.tutors        = "Prof. Dr. John Doe, Max Mustermann"
  #        s.shared_secret = "12345"
  #        if s.valid?
  #          s.save!
  #        else
  #          puts "SemApp #{i} is not valid:"
  #          s.errors.each {|attr,msg| puts "\t#{attr} - #{msg}"}
  #        end
  #      end
  #    end
  #  end

end

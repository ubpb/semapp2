# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

SemApp.transaction do

  Authority.create({:name => Authority::ADMIN_ROLE})
  admin_role = Authority.find_by_name(Authority::ADMIN_ROLE)

  admin_user = User.create({
      :login                 => 'admin',
      :password              => 'password',
      :password_confirmation => 'password',
      :email                 => 'joe.blogs@example.com',
      :firstname             => 'Joe',
      :lastname              => 'Blogs',
      :active                => true,
      :approved              => true
    })
  admin_user.authorities << admin_role if admin_role

  default_user = User.create({
      :login                 => 'john.doe',
      :password              => 'password',
      :password_confirmation => 'password',
      :email                 => 'john.doe@example.com',
      :firstname             => 'John',
      :lastname              => 'Doe',
      :active                => true,
      :approved              => true
    })

  # Semesters
  Semester.create({:title => 'Sommersemester 2010',      :position => 0, :current => false})
  default_semester = Semester.create({:title => 'Wintersemester 2009/2010', :position => 1, :current => true})

  # Locations
  default_location = Location.create({:title => 'Fachbibliothek für Kunstwissenschaften',                   :position => 0})
  Location.create({:title => 'Fachbibliothek für Geisteswissenschaften',                 :position => 1})
  Location.create({:title => 'Fachbibliothek für Naturwissenschaften',                   :position => 2})
  Location.create({:title => 'Fachbibliothek für Sprach- und Literaturwissenschaften',   :position => 3})
  Location.create({:title => 'Fachbibliothek für Wirtschafts- und Sozialwissenschaften', :position => 4})
  Location.create({:title => 'Fachbibliothek für Fürstenallee',                          :position => 5})

  # Sem App
  default_semapp = SemApp.create({
      :creator       => default_user,
      :semester      => default_semester,
      :location      => default_location,
      :approved      => true,
      :title         => 'Default Sem App',
      :tutors        => 'Prof. Dr. Meyer',
      :shared_secret => 'secret'
    })
  default_semapp.add_ownership(default_user)

  # Book Shelves
  BookShelf.create({:sem_app => default_semapp, :ils_account => 'PE70000010', :slot_number => '10'})

  # Media entries
  SemAppHeadlineEntry.create({:sem_app => default_semapp, :headline => 'Some Headline'})
  SemAppHeadlineEntry.create({:sem_app => default_semapp, :headline => 'Another Headline'})

end # end transaction
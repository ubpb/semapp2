SemApp.transaction do

  # This file should contain all the record creation needed to seed the database with its default values.
  # The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

  Authority.create!(:name => Authority::ADMIN_ROLE)
  Authority.create!(:name => Authority::LECTURER_ROLE)
  Authority.create!(:name => Authority::ASSISTANT_ROLE)

  # Default Admin user
  User.create!(
    :login => 'PA06003114',
    :name  => 'René Sprotte',
    :email => 'r.sprotte@ub.uni-paderborn.de'
  ).authorities << Authority.find_by_name(Authority::ADMIN_ROLE)

  # Semesters
  Semester.create!(:title => 'Sommersemester 2010',      :position => 0,  :current => true)
  Semester.create!(:title => 'Wintersemester 2009/2010', :position => 1,  :current => false)
  Semester.create!(:title => 'Sommersemester 2009',      :position => 2,  :current => false)
  Semester.create!(:title => 'Wintersemester 2008/2009', :position => 3,  :current => false)
  Semester.create!(:title => 'Sommersemester 2008',      :position => 4,  :current => false)
  Semester.create!(:title => 'Wintersemester 2007/2008', :position => 5,  :current => false)
  Semester.create!(:title => 'Sommersemester 2007',      :position => 6,  :current => false)
  Semester.create!(:title => 'Wintersemester 2006/2007', :position => 7,  :current => false)
  Semester.create!(:title => 'Sommersemester 2006',      :position => 8,  :current => false)
  Semester.create!(:title => 'Wintersemester 2005/2006', :position => 9,  :current => false)
  Semester.create!(:title => 'Sommersemester 2005',      :position => 10, :current => false)

  # Locations
  Location.create!(:title => 'Fachbibliothek für Kunstwissenschaften',                   :position => 0)
  Location.create!(:title => 'Fachbibliothek für Geisteswissenschaften',                 :position => 1)
  Location.create!(:title => 'Fachbibliothek für Naturwissenschaften',                   :position => 2)
  Location.create!(:title => 'Fachbibliothek für Sprach- und Literaturwissenschaften',   :position => 3)
  Location.create!(:title => 'Fachbibliothek für Wirtschafts- und Sozialwissenschaften', :position => 4)
  Location.create!(:title => 'Fachbibliothek für Fürstenallee',                          :position => 5)

  # Sem App
#  20.times do |i|
#    default_semapp = SemApp.create!(
#      :creator       => default_user,
#      :semester      => default_semester,
#      :location      => default_location,
#      :approved      => true,
#      :title         => 'Seminarapparat #' + i.to_s,
#      :tutors        => 'Prof. Dr. Meyer',
#      :shared_secret => 'secret'
#    )
#
#    # Book Shelves
#    if i == 1
#      BookShelf.create!(:sem_app => default_semapp, :ils_account => "PE70000010", :slot_number => '10')
#    end
#
#    # Media entries
#    HeadlineEntry.create!(:sem_app => default_semapp, :headline => 'Headline', :position => 0)
#    TextEntry.create!(:sem_app => default_semapp, :text => 'Lorem Ipsum ...', :position => 1)
#  end

end # end transaction

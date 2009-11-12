# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

Authority.create({:name => Authority::ADMIN_ROLE})
admin_role = Authority.find_by_name(Authority::ADMIN_ROLE)

User.transaction do
  u = User.create({
      :login                 => 'admin',
      :password              => 'admin',
      :password_confirmation => 'admin',
      :email                 => 'admin@example.com',
      :firstname             => 'John',
      :lastname              => 'Doe',
      :active                => true,
      :approved              => true
    })
  u.authorities << admin_role if admin_role
end

Semester.create({:title => 'Wintersemester 2009/2010', :position => 1, :current => true})
Semester.create({:title => 'Sommersemester 2010',      :position => 0, :current => false})

Location.create({:title => 'Fachbibliothek für Kunstwissenschaften',                   :position => 0})
Location.create({:title => 'Fachbibliothek für Geisteswissenschaften',                 :position => 1})
Location.create({:title => 'Fachbibliothek für Naturwissenschaften',                   :position => 2})
Location.create({:title => 'Fachbibliothek für Sprach- und Literaturwissenschaften',   :position => 3})
Location.create({:title => 'Fachbibliothek für Wirtschafts- und Sozialwissenschaften', :position => 4})
Location.create({:title => 'Fachbibliothek für Fürstenallee',                          :position => 5})
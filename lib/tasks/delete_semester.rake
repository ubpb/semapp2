namespace :app do

  desc 'Deletes a semester (including all semapps and files)'
  task :delete_semester => :environment do
    Semester.order('id').each{ |s| puts "#{s.id}: #{s.title}" }

    semester_id = ask("Welches Semester soll gelöscht werden (ID)?").try(:to_i)
    if semester_id.blank? || semester_id == 0
      puts "Abbruch"
      next
    end

    semester = Semester.find(semester_id)
    if agree("'#{semester.id}: #{semester.title}' und alle Dateien unwiederuflich löschen (yes oder no)?")
      puts "Löschen gestartet..."
      Semester.transaction do
        semester.destroy
      end
      puts "Fertig!"
    else
      puts "Abbruch"
    end
  end


end

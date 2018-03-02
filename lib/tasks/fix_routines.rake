namespace :app do
  namespace :fix do

    BATCH_SIZE = 1000.freeze

    desc 'Fix leading and trailing whitespaces for some sem app fields like title.'
    task sem_app_whitespace: :environment do
      i = 1
      SemApp.all.find_in_batches(batch_size: BATCH_SIZE) do |group|
        print "# Fixing SemApp #{i}..#{(i = i+BATCH_SIZE) - 1} "

        time = Benchmark.realtime do
          group.each do |sem_app|
            sem_app.title     = sem_app.title.try(:squish)
            sem_app.tutors    = sem_app.tutors.try(:squish)
            sem_app.course_id = sem_app.course_id.try(:squish)
            sem_app.save!(validate: false)
          end
        end

        print "(#{time} sec.)\n"
      end
    end

    desc "fix books for SS 2018 sem apps"
    task fix_ss_2018_books: :environment do
      ss18_id = 27
      ws17_18_id = 26

      BookShelf.joins(:sem_app => :semester).where("semesters.id" => ss18_id).each do |ss_shelf|
        # Suche ein passendes WS Regal
        ws_shelf = BookShelf.joins(:sem_app => :semester).where("semesters.id" => ws17_18_id).where(ils_account: ss_shelf.ils_account).where(slot_number: ss_shelf.slot_number).first
        # Wenn ich das gefunden habe, übertrage alle Stellvertreter und Referenzen aus dem WS in das SS
        if ws_shelf
          ss_sem_app = ss_shelf.sem_app
          ws_sem_app = ws_shelf.sem_app

          if ws_sem_app.books.present?
            SemApp.transaction do
              ws_sem_app.books.each do |ws_book|
                if ws_book.placeholder? || ws_book.reference_copy?
                  ss_book = ss_sem_app.books.find_by(ils_id: ws_book.ils_id)
                  if ss_book.nil?
                    clone = ws_book.dup
                    clone.sem_app = ss_sem_app
                    clone.save!(validate: false)
                  end
                end
              end
            end

            puts "OK: Alle fehlenden Stellvertreter und Verweise von SemApp #{ws_sem_app.id} aus dem WS an den SemApp #{ss_sem_app.id} aus dem SS übertragen."
          end
        else
          puts "Error: Für SemApp #{ss_shelf.sem_app.id} aus dem SS konnte kein entsprechender SemApp im WS gefunden werden."
        end
      end
    end

  end
end

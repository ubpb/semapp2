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

    desc "fix missing call numbers"
    task missing_call_numbers: :environment do
      Book.where(signature: nil).each do |book|
        record_id = book.ils_id

        if record_id && record_id.starts_with?("99")
          if title = AlmaConnector.get_title(record_id)
            call_number = title["call_number"]

            puts "#{record_id} => #{call_number}"

            if call_number.present?
              book.update(signature: call_number)
            end
          end
        end
      end
    end

  end
end

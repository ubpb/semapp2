class SyncEngine

  def initialize(adapter)
    raise "Adapter is not valid" unless adapter or adapter.is_a?(SyncEngineAdapter)
    @adapter = adapter
  end

  def sync
    sem_apps = load_sem_apps

    started_on = Time.now

    puts "#"
    puts "# Started Book Synchronization #{started_on}"
    puts "#"
    puts "# Found #{sem_apps.size} app(s) for the current semester: #{Semester.current.title}"
    puts "#\n\n"

    sem_apps.each do |sem_app|
      sync_sem_app(sem_app)
    end

    puts "\n#"
    puts "# Synchronization finished in #{Time.now - started_on} sec."
    puts "# #{@errors} Error(s)"
    puts "#"
  end

  def sync_sem_app(sem_app)
    print "Syncing #{sem_app.id}: "
    @errors ||= 0

    if sem_app.has_book_shelf?
      begin
        # load the books for this sem_app (loaned for this sem app)
        ils_books = @adapter.get_ils_books(sem_app.book_shelf.ils_account)

        # give the adapter a chance to manipulate/fix records before sync
        @adapter.fix_db_books(sem_app)
        # load the books that are already in the database
        db_books = sem_app.books

        # Sync ...
        SemApp.transaction do
          # iterate over all ils entries
          ils_books.each do |ils_book|
            create_or_update_db_book(sem_app, ils_book)
          end

          # iterate over all db entries
          db_books.each do |db_book|
            # Ignore placeholders
            next if db_book.placeholder?
            # Ignore reference copies
            next if db_book.reference_copy?
            # Ignore ebook references
            next if db_book.ebook_reference?

            # Handle books that are not in ILS
            if (ils_books.find{|b| b[:ils_id] == db_book.ils_id}).nil?
              # Delete Books in state "rejected"
              if db_book.state == Book::States[:rejected]
                delete_db_book(db_book)
              end
            end
          end
        end

        # finished we are
        print "=> Ok!"
      rescue Exception => e
        @errors += 1
        print "=> Error!\n"
        print "Error message: #{e.message}\n"
        print "Error backtrace:\n"
        puts e.backtrace
      ensure
        print "\n"
      end
    else
      print "Skipped (no book shelf)\n"
    end
  end

  private

  def load_sem_apps
    current_semester = Semester.current
    raise "No current semester" unless current_semester
    return SemApp.where(semester: current_semester)
  end

  def create_or_update_db_book(sem_app, ils_book)
    attributes = {
      sem_app_id: sem_app.id,
      ils_id:     ils_book[:ils_id],
      signature:  ils_book[:signature],
      title:      ils_book[:title],
      author:     ils_book[:author],
      year:       ils_book[:year],
      edition:    ils_book[:edition],
      place:      ils_book[:place],
      publisher:  ils_book[:publisher],
      isbn:       ils_book[:isbn]
    }

    # Check if this book exists in db, then update or create
    # the record.
    if db_book = sem_app.book_by_ils_id(attributes[:ils_id])
      update_db_book(db_book, attributes)
    else
      create_db_book(attributes)
    end
  end

  def create_db_book(attributes)
    db_book = Book.new(attributes)
    db_book.state = Book::States[:in_shelf]

    unless db_book.save(validate: false)
      raise "Failed for ILS ID #{db_book[:ils_id]} while creating new record. Message: #{db_book.errors.full_messages.to_sentence}"
    end
  end

  def update_db_book(db_book, attributes)
    # ignore books that are rejected
    return if db_book.state == Book::States[:rejected]

    db_book.attributes = attributes
    db_book.state = Book::States[:in_shelf]

    unless db_book.save(validate: false)
      raise "Failed for ILS ID #{db_book[:ils_id]} while updating existing record. Message: #{db_book.errors.full_messages.to_sentence}"
    end
  end

  def delete_db_book(db_book)
    Book.destroy(db_book.id)
  end

end

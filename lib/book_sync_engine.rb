class BookSyncEngine

  def initialize(connector)
    raise "Connector is not valid" unless connector or connector.class == AbstractConnector
    @connector = connector
  end

  def sync
    sem_apps = load_sem_apps

    started_on = Time.now()

    puts "#"
    puts "# Started Book Synchronization #{started_on}"
    puts "#"
    puts "# Found #{sem_apps.size} app(s) for the current semester: #{Semester.current.title}"
    puts "#\n\n"
    
    sem_apps.each_with_index do |sem_app, i|
      sync_sem_app(sem_app, i)
    end

    puts "\n#"
    puts "# Synchronization finished in #{Time.now()-started_on}s"
    puts "#"
  end

  private

  def load_sem_apps
    current_semester = Semester.current
    raise "No current semester" unless current_semester
    return SemApp.find_all_by_semester_id(current_semester.id)
  end

  def sync_sem_app(sem_app, index)
    print "#{index+1}. Syncing SemApp #{sem_app.id}: "
    
    if sem_app.has_book_shelf?
      begin
        # load the books for this sem_app
        ils_entries = @connector.get_books(sem_app.book_shelf.ils_account)
        db_entries  = mergable_hash_from_db_entries(sem_app.books(:all => true))

        # sync the books
        SemApp.transaction do
          # iterate over all card entries
          ils_entries.each do |s, e|
            unless db_entries.include?(s)
              # found a book that is in the ILS AND NOT in the db
              create_or_update_entry(sem_app, s, e)
            else
              # found a book that is in the ILS AND in the db
              create_or_update_entry(sem_app, s, e)
            end
          end
          # iterate over all db entries
          db_entries.each do |s, e|
            unless ils_entries.include?(s)
              # found a book that is in the db AND NOT in the ILS
              delete_entry(e)
            else
              # found a book that is in the db AND in the ILS
              # do nothing: handled in the other case
            end
          end
        end
        
        # finished we are
        print "Done."
      rescue RuntimeError => e
        print "Error! #{e}"
      ensure
        print "\n"
      end
    else
      print "Skipped. Has no book shelf applied."
    end
  end

  def mergable_hash_from_db_entries(db_entries)
    m = {}
    db_entries.each {|e| m[e.signature] = e }
    return m
  end

  #
  # ILS Entry:
  #   :title
  #   :author
  #   :edition
  #   :place
  #   :publisher
  #   :year
  #   :isbn
  #
  def create_or_update_entry(sem_app, signature, ils_entry)
    options = {
      :sem_app   => sem_app,
      :signature => signature,
      :title     => ils_entry[:title],
      :author    => ils_entry[:author],
      :year      => ils_entry[:year],
      :edition   => ils_entry[:edition],
      :place     => ils_entry[:place],
      :publisher => ils_entry[:publisher],        
      :isbn      => ils_entry[:isbn],
    }

    db_entry = sem_app.book_by_signature(signature)
    db_entry ? update_entry(db_entry, options) : create_entry(options)
  end

  def create_entry(options)
    unless Book.new(options).save(false)
      raise "Failed for signature #{options[:signature]} while creating a new entry."
    end
  end

  def update_entry(db_entry, options)
    options.merge!({:scheduled_for_addition => false})
    db_entry.update_attributes(options)
    unless db_entry.save(false)
      raise "Failed for signature #{options[:signature]} while updating an exsisting entry."
    end
  end

  def delete_entry(db_entry)
    entry = Book.find(db_entry.id)
    entry.destroy if entry
  end

end

class BookSyncEngine

  def initialize(connector)
    raise "Connector is not valid" unless connector or connector.class == AbstractConnector
    @connector = connector
  end

  def sync
    puts "Started Book Synchronization #{Time.now()}"
    sem_apps = load_sem_apps
    puts "Found #{sem_apps.size} app(s) for the current semester: #{Semester.current.title}"
    sem_apps.each do |sem_app|
      sync_sem_app(sem_app)
    end
  end

  private

  def load_sem_apps
    current_semester = Semester.current
    raise "No current semester" unless current_semester
    return SemApp.find_all_by_semester_id(current_semester.id)
  end

  def sync_sem_app(sem_app)
    print "Syncing SemApp #{sem_app.id}:"
    if sem_app.has_book_shelf?
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
            # do nothing
          end
        end
        # iterate over all db entries
        db_entries.each do |s, e|
          unless ils_entries.include?(s)
            # found a book that is in the db AND NOT in the ILS
            delete_entry(e)
          else
            # found a book that is in the db AND in the ILS
            # do nothing
          end
        end
      end
      # finished we are
      print " Done.\n"
    else
      print " Skipped.\n"
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
      :title     => ils_entry[:title].present?   ? ils_entry[:title]   : 'n.n.',
      :author    => ils_entry[:author].present?  ? ils_entry[:author]  : 'n.n.',
      :year      => ils_entry[:year].present?    ? ils_entry[:year]    : 'n.n.',
      :edition   => ils_entry[:edition].present? ? ils_entry[:edition] : 'n.n.',
      :place     => ils_entry[:place],
      :publisher => ils_entry[:publisher],        
      :isbn      => ils_entry[:isbn],
    }

    db_entry = sem_app.book_by_signature(signature)
    db_entry ? update_entry(db_entry, options) : create_entry(options)
  end

  def create_entry(options)
    Book.new(options).save!
  end

  def update_entry(db_entry, options)
    options.merge!({:scheduled_for_addition => false})
    db_entry.update_attributes(options)
    db_entry.save!
  end

  def delete_entry(db_entry)
    entry = Book.find(db_entry.id)
    entry.destroy if entry
  end

end

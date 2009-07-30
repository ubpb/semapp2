class BookSyncEngine

  def initialize(connector)
    raise "Connector is not valid" unless connector or connector.class == AbstractConnector
    @connector = connector
  end

  def sync
    puts "Started Book Synchronization #{Time.now()}"
    sem_apps = load_sem_apps
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
    if sem_app.bid.present? and sem_app.ref.present?
      # load the books for this sem_app
      card_entries = @connector.get_books(sem_app.bid)
      db_entries   = mergable_hash_from_db_entries(sem_app.book_entries(:all => true))

      print " #{card_entries.size} items on card, #{db_entries.size} entries in db."
      
      # sync the books
      SemApp.transaction do
        # iterate over all card entries
        card_entries.each do |s, e|
          unless db_entries.include?(s)
            # found a book that is on the card AND NOT in the db
            # TODO: create a new entry
            puts "Create entry for #{s}"
          else
            # found a book that is on the card AND in the db
            # do nothing
          end
        end
        # iterate over all db entries
        db_entries.each do |s, e|
          unless db_entries.include?(s)
            # found a book that is in the db AND NOT on the card
            # TODO: Delete the entry in the db
            puts "Delete entry for #{s}"
          else
            # found a book that is in the db AND on the card
            # do nothing
          end
        end
      end
      # finished we are
      print " Done.\n"
    else
      print " Skiped.\n"
    end
  end

  def mergable_hash_from_db_entries(db_entries)
    m = {}
    db_entries.each {|e| m[e.instance.signature] = e }
    return m
  end

end

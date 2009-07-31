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
            create_entry(sem_app, s, e)
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
            delete_entry(e)
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

  #
  # Card Entry:
  #   :title
  #   :author
  #   :edition
  #   :place
  #   :publisher
  #   :year
  #   :isbn
  #
  def create_entry(sem_app, signature, card_entry)
    db_entry = sem_app.book_by_signature(signature)
    if db_entry
      update_entry(db_entry, card_entry)
    else
      book_entry = SemAppBookEntry.new
      book_entry.signature = signature
      book_entry.title     = card_entry[:title]
      book_entry.author    = card_entry[:author]
      book_entry.edition   = card_entry[:edition]
      book_entry.place     = card_entry[:place]
      book_entry.publisher = card_entry[:publisher]
      book_entry.year      = card_entry[:year]
      book_entry.isbn      = card_entry[:isbn]

      sem_app_entry = SemAppEntry.new(:sem_app => sem_app, :instance => book_entry)

      book_entry.save!
      sem_app_entry.save!
    end
  end

  def update_entry(db_entry, card_entry)
    card_entry.merge!({:scheduled_for_addition => false})
    db_entry.instance.update_attributes(card_entry).save!
  end

  def delete_entry(db_entry)
    db_entry.destroy!
  end

end

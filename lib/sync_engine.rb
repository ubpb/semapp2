# encoding: utf-8

class SyncEngine

  def initialize(adapter)
    raise "Adapter is not valid" unless adapter or adapter.is_a?(SyncEngineAdapter)
    @adapter = adapter
  end

  def sync
    sem_apps = load_sem_apps

    started_on = Time.now()

    puts "#"
    puts "# Started Book Synchronization #{started_on}"
    puts "#"
    puts "# Found #{sem_apps.size} app(s) for the current semester: #{Semester.current.title}"
    puts "#\n\n"

    @errors = 0
    sem_apps.each do |sem_app|
      sync_sem_app(sem_app)      
    end

    puts "\n#"
    puts "# Synchronization finished in #{Time.now()-started_on}s"
    puts "# #{@errors} Error(s)"
    puts "#"
  end

  def sync_sem_app(sem_app)
    print "Syncing #{sem_app.id}... "
    
    if sem_app.has_book_shelf?
      begin
        # load the books for this sem_app
        ils_entries = @adapter.get_books(sem_app.book_shelf.ils_account)
        db_entries  = mergable_hash_from_db_entries(sem_app.books)

        # sync the books
        SemApp.transaction do
          # iterate over all card entries
          ils_entries.each do |s, e|
            unless db_entries.include?(s)
              # found a book that is in the ILS AND NOT in the db => Create
              create_or_update_entry(sem_app, s, e)
            else
              # found a book that is in the ILS AND in the db => Update
              create_or_update_entry(sem_app, s, e)
            end
          end
          # iterate over all db entries
          db_entries.each do |s, e|
            unless ils_entries.include?(s)
              # found a book that is in the db AND NOT in the ILS
              # skip placeholder, reference copies and states !=
              # in shelf
              next if e.placeholder?
              next if e.reference_copy.present?
              next if e.state != Book::States[:in_shelf]
              
              delete_entry(e) 
            else
              # found a book that is in the db AND in the ILS
              # do nothing: handled in the other case
            end
          end
        end
        
        # finished we are
        print "Ok."
      rescue Exception => e
        puts e.backtrace
        @errors += 1
        print "Error! #{e}"
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
    return SemApp.find_all_by_semester_id(current_semester.id)
  end

  def mergable_hash_from_db_entries(db_entries)
    m = {}
    db_entries.each {|e| m[e.ils_id] = e }
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
  def create_or_update_entry(sem_app, ils_id, ils_entry)
    options = {
      :sem_app     => sem_app,
      :ils_id      => ils_id,
      :placeholder => nil,
      :signature   => ils_entry[:signature] || 'n.n',
      :title       => ils_entry[:title] || 'n.n',
      :author      => ils_entry[:author] || 'n.n',
      :year        => ils_entry[:year],
      :edition     => ils_entry[:edition],
      :place       => ils_entry[:place],
      :publisher   => ils_entry[:publisher],
      :isbn        => ils_entry[:isbn]
    }

    db_entry = sem_app.book_by_ils_id(ils_id)
    db_entry ? update_entry(db_entry, options) : create_entry(options)
  end

  def create_entry(options)
    book = Book.new(options)
    book.state = "in_shelf"
    unless book.save(false)
      raise book.errors.full_messages.to_sentence
    end
  end

  def update_entry(db_entry, options)
    # ignore books that are rejected
    if db_entry.state != Book::States[:rejected]
      options[:state] = :in_shelf
    end

    unless db_entry.update_attributes(options)
      raise "Failed for signature #{options[:signature]} while updating an exsisting entry."
    end
  end

  def delete_entry(db_entry)
    entry = Book.find(db_entry.id)
    entry.destroy if entry
  end

end

class SyncEngineAdapter

  def initialize(options)
  end

  def get_books(ils_account)
    raise "implement in your subclass"
  end

  def fix_db_entries(db_entries)
    db_entries
  end

end

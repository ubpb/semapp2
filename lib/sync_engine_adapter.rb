class SyncEngineAdapter

  def initialize(options)
  end

  def get_ils_books(ils_account)
    raise "implement in your subclass"
  end

  def fix_db_books(sem_app)
  end

end

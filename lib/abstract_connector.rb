class AbstractConnector
  
  def initialize(options = {})
  end

  def get_books(sem_app_id)
    raise "override get_books!"
  end

end

class AbstractConnector
  
  def initialize(options = {})
  end

  def get_books(ils_account)
    raise "override get_books!"
  end

end

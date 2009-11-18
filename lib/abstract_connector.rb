class AbstractConnector
  
  def initialize(options = {})
  end

  def get_lendings(ils_account_no, options = {})
    raise "override get_lendings in your subclass"
  end

  def get_record(doc_number)
    raise "override get_record in your subclass"
  end

end

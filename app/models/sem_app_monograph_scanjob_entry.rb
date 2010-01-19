class SemAppMonographScanjobEntry < SemAppMonographReferenceEntry

  set_table_name :sem_app_monograph_scanjob_entries
  
  belongs_to :sem_app
  has_many   :attachments, :class_name => '::Attachment', :dependent => :destroy, :foreign_key => 'sem_app_entry_id'
  accepts_nested_attributes_for :attachments, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  attr_accessor :current_request_params

  validates_presence_of :pages
  validates_presence_of :signature
  validates_presence_of :year

  protected

  def before_validation
    if self.signature.present? and 
        self.current_request_params.present? and
        self.current_request_params[:lookup_signature].present?
      begin
        aleph  = Aleph::Connector.new
        result = aleph.find("psg=#{self.signature}")
        if result.present? and result[1] >= 1
          records = aleph.get_records(result[0])

          self.title  = records[0].title
          self.author = records[0].author
          self.year   = records[0].year
          
          return false
        end
      rescue Exception => e
        puts e.message
        puts e.backtrace
      end
    end
  end

end

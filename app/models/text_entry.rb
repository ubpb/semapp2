class TextEntry < Entry

  # Realations
  belongs_to :sem_app

  #has_many   :attachments, :class_name => '::Attachment', :dependent => :destroy, :foreign_key => 'entry_id'
  
  # Behavior
  set_table_name :text_entries
  #accepts_nested_attributes_for :attachments, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  # Validation
  validates_presence_of :text

end

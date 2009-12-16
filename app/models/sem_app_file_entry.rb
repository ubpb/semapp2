class SemAppFileEntry < SemAppEntry

  set_table_name :sem_app_file_entries

  belongs_to :sem_app
  has_many   :attachments, :class_name => '::Attachment', :dependent => :destroy, :foreign_key => 'sem_app_entry_id'
  accepts_nested_attributes_for :attachments, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  validates_presence_of :description

end

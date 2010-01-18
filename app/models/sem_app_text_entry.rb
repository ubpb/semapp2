# == Schema Information
# Schema version: 20091110135349
#
# Table name: sem_app_text_entries
#
#  id         :integer         not null, primary key
#  sem_app_id :integer         not null
#  position   :integer
#  publish_on :datetime
#  created_at :datetime
#  updated_at :datetime
#  body_text  :text            not null
#

class SemAppTextEntry < SemAppEntry
  
  set_table_name :sem_app_text_entries

  belongs_to :sem_app
  has_many   :attachments, :class_name => '::Attachment', :dependent => :destroy, :foreign_key => 'sem_app_entry_id'
  accepts_nested_attributes_for :attachments, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  validates_presence_of :body_text

end

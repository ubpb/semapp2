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
  validates_presence_of :body_text

end

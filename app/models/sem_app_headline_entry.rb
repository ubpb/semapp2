# == Schema Information
# Schema version: 20091110135349
#
# Table name: sem_app_headline_entries
#
#  id         :integer         not null, primary key
#  sem_app_id :integer         not null
#  position   :integer
#  publish_on :datetime
#  created_at :datetime
#  updated_at :datetime
#  headline   :string(255)     not null
#

class SemAppHeadlineEntry < SemAppEntry
  set_table_name :sem_app_headline_entries

  belongs_to :sem_app
  validates_presence_of :headline

end

# == Schema Information
# Schema version: 20091110135349
#
# Table name: sem_app_headline_entries
#
#  id       :integer(4)      not null, primary key
#  headline :string(255)     not null
#

class SemAppHeadlineEntry < SemAppEntry
  set_table_name :sem_app_headline_entries

  belongs_to :sem_app
  validates_presence_of :headline

end

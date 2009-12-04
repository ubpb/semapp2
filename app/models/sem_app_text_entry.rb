# == Schema Information
# Schema version: 20091110135349
#
# Table name: sem_app_text_entries
#
#  id        :integer(4)      not null, primary key
#  body_text :text            default(""), not null
#

class SemAppTextEntry < SemAppEntry
  set_table_name :sem_app_text_entries

  belongs_to :sem_app
  validates_presence_of :body_text

end

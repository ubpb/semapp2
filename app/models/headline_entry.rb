# encoding: utf-8

class HeadlineEntry < Entry

  # Relations
  belongs_to :sem_app

  # Behavior
  self.table_name = :headline_entries

  # Validation
  validates_presence_of :headline

end
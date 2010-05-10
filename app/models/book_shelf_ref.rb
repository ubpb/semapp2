# encoding: utf-8

class BookShelfRef < ActiveRecord::Base

  # Relations
  belongs_to :sem_app
  belongs_to :sem_app_ref, :class_name => 'SemApp', :foreign_key => 'sem_app_ref_id'

  # Validations
  validates_presence_of :sem_app_id
  validates_presence_of :sem_app_ref_id
  validate :ref_must_exists
  validate :ref_must_have_a_book_shelf

  def ref_must_exists
    unless is_sem_app_id?(self.sem_app_ref_id)
      errors.add(:sem_app_ref_id, "Ist kein Seminarapparat")
    end
  end

  def ref_must_have_a_book_shelf
    unless has_book_shelf?(self.sem_app_ref_id)
      errors.add(:sem_app_ref_id, "Der Apparat hat keine Regalzuordnung")
    end
  end

  private

  def is_sem_app_id?(id)
    SemApp.find_by_id(id)
  end

  def has_book_shelf?(id)
    sem_app = is_sem_app_id?(id)
    sem_app.present? and sem_app.has_book_shelf?
  end

end

class Entry < ActiveRecord::Base

  # Realations
  belongs_to :sem_app

  # Behavior
  acts_as_inheritance_root
  #acts_as_list :scope => :sem_app

  # Validation
  validates_presence_of :sem_app

  # Scopes
  named_scope :for_sem_app, lambda { |sem_app| { :conditions => { :sem_app_id => sem_app.id } } }
  named_scope :ordered_by,  lambda { |*order| { :order => order.flatten.first || 'position asc' } }

  #################################################################################
  #
  # Public API
  #
  #################################################################################

  def to_be_published
    self.publish_on.present? and self.publish_on >= Time.new
  end

end
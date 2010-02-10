class Entry < ActiveRecord::Base

  # Realations
  belongs_to :sem_app
  belongs_to :creator, :class_name => 'User'
  has_many :file_attachments, :dependent => :destroy
  has_one :scanjob, :dependent => :destroy

  # Behavior
  acts_as_inheritance_root

  # Validation
  validates_presence_of :sem_app

  # Scopes
  named_scope :for_sem_app, lambda { |sem_app| { :conditions => { :sem_app_id => sem_app.id }, :include => [:file_attachments, :scanjob] } }
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
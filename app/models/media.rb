class Media < ApplicationRecord

  # Realations
  belongs_to :sem_app, :touch => true
  belongs_to :creator, :class_name => 'User', optional: true
  has_many   :file_attachments, :dependent => :destroy
  has_one    :scanjob, :dependent => :destroy

  # Validation
  validates_presence_of :sem_app

  # Scopes
  scope :for_sem_app, lambda { |sem_app| where( sem_app_id: sem_app.id ).includes( :file_attachments, :scanjob ) }
  scope :ordered_by,  lambda { |*order| order( order.flatten.first || 'position asc' ) }

  # Behavior
  acts_as_media_parent

  def currently_hidden?
    self.hidden || (self.hidden_until.present? && self.hidden_until > Time.zone.now)
  end

end

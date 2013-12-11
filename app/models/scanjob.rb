class Scanjob < ActiveRecord::Base

  States = {
    :ordered  => "ordered",  # the scanjob is new
    :accepted => "accepted", # the scanjob was accepted by the library staff
    :rejected => "rejected", # the scanjob was rejected by the library staff
    :deferred => "deferred"  # the scanjob was deferred by the library staff (same as accepted but currently on hold)
  }.freeze

  # Realations
  belongs_to :media, :touch => true
  belongs_to :creator, :class_name => 'User'

  # Validation
  validates_presence_of :media
  validates_presence_of :signature
  validates_presence_of :pages_from
  validates_presence_of :pages_to
  validates_numericality_of :pages_from, :only_integer => true
  validates_numericality_of :pages_to, :only_integer => true
  validates_acceptance_of :accepts_copyright

  # Scopes
  scope :ordered,    lambda { where( state: Scanjob::States[:ordered]  ).includes( :media => :sem_app ) }
  scope :accepted,   lambda { where( state: Scanjob::States[:accepted] ).includes( :media => :sem_app ) }
  scope :rejected,   lambda { where( state: Scanjob::States[:rejected] ).includes( :media => :sem_app ) }
  scope :deferred,   lambda { where( state: Scanjob::States[:deferred] ).includes( :media => :sem_app ) }
  scope :ordered_by, lambda { |*order| order( order.flatten.first || 'created_at' ) }

  # virtual attributes
  attr_accessor :accepts_copyright

  #################################################################################
  #
  # Public API
  #
  #################################################################################

  def state=(value)
    if value.present? and States[value.to_sym].present?
      write_attribute(:state, States[value.to_sym])
    end
  end

  def set_state(value)
    if value.present? and States[value.to_sym].present?
      update_attribute(:state, States[value.to_sym])
    end
  end

  def code
    "scanjob-#{self.id}.pdf"
  end

  ###########################################################################################
  #
  # AR Callbacks
  #
  ###########################################################################################

  before_create :ensure_state

  def ensure_state
    if self.state.blank?
      self.state = Scanjob::States[:ordered]
    end
  end

end

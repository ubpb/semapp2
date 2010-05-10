# encoding: utf-8

class Scanjob < ActiveRecord::Base

  States = {
    :ordered  => "ordered",  # the scanjob is new
    :accepted => "accepted", # the scanjob was accepted by the library staff
    :rejected => "rejected", # the scanjob was rejected by the library staff
    :deferred => "deferred"  # the scanjob was deferred by the library staff (same as accepted but currently on hold)
  }.freeze

  # Realations
  belongs_to :entry, :touch => true
  belongs_to :creator, :class_name => 'User'

  # Validation
  validates_presence_of :entry
  validates_presence_of :signature
  validates_presence_of :pages_from
  validates_presence_of :pages_to
  validates_numericality_of :pages_from, :only_integer => true
  validates_numericality_of :pages_to, :only_integer => true

  # Scopes
  named_scope :ordered,    lambda { { :conditions => { :state => Scanjob::States[:ordered]  }, :include => {:entry => :sem_app} } }
  named_scope :accepted,   lambda { { :conditions => { :state => Scanjob::States[:accepted] }, :include => {:entry => :sem_app} } }
  named_scope :rejected,   lambda { { :conditions => { :state => Scanjob::States[:rejected] }, :include => {:entry => :sem_app} } }
  named_scope :deferred,   lambda { { :conditions => { :state => Scanjob::States[:deferred] }, :include => {:entry => :sem_app} } }
  named_scope :ordered_by, lambda { |*order| { :order => order.flatten.first || 'created_at'  } }

  #################################################################################
  #
  # Public API
  #
  #################################################################################

  def state=(value)
    if value.present? and States[value.to_sym].present?
      self.write_attribute(:state, States[value.to_sym])
    end
  end

  def set_state(value)
    if value.present? and States[value.to_sym].present?
      self.update_attribute(:state, States[value.to_sym])
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

  def before_create
    if self.state.blank?
      self.state = Scanjob::States[:ordered]
    end
  end

end
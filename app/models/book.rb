# encoding: utf-8

class Book < ActiveRecord::Base

  States = {
    :ordered  => "ordered",  # the book is marked to be added to the shelf
    :in_shelf => "in_shelf", # the book was placed in the sem app shelf
    :rejected => "rejected", # the book is marked to be removed from the shelf
    :deferred => "deferred"  # the book is deferred
  }.freeze

  # Relations
  belongs_to :sem_app
  belongs_to :creator,     :class_name => 'User'
  belongs_to :placeholder, :class_name => 'SemApp'

  # Validation
  validates_presence_of   :sem_app
  validates_presence_of   :ils_id
  validates_uniqueness_of :ils_id, :scope => :sem_app_id, :message => "Dieses Exemplar befindet sich bereits in Ihrem eSeminarapparat."
  validates_presence_of   :signature
  validates_presence_of   :title
  validates_presence_of   :author

  # Scopes
  named_scope :for_sem_app, lambda { |sem_app| { :conditions => { :sem_app_id => sem_app.id } } }
  named_scope :ordered,     lambda { { :conditions => { :state => Book::States[:ordered] } } }
  named_scope :in_shelf,    lambda { { :conditions => { :state => Book::States[:in_shelf] } } }
  named_scope :removed,     lambda { { :conditions => { :state => Book::States[:rejected] } } }
  named_scope :deferred,    lambda { { :conditions => { :state => Book::States[:deferred] } } }
  named_scope :ordered_by,  lambda { |*order| { :order => order.flatten.first || 'title DESC' } }
  
  ###########################################################################################
  #
  # Public API
  #
  ###########################################################################################

  def state=(value)
    if value.present? and States[value.to_sym].present?
      self.write_attribute(:state, States[value.to_sym])
    else
      self.write_attribute(:state, '')
    end
  end

  def set_state(value)
    if value.present? and States[value.to_sym].present?
      self.update_attribute(:state, States[value.to_sym])
    end
  end

  def base_signature
    Book.get_base_signature(signature)
  end

  def placeholder?
    placeholder.present?
  end

  ###########################################################################################
  #
  # Class Methods
  #
  ###########################################################################################

  def self.get_base_signature(signature)
    if signature.present?
      signature[/(.+)(\(|\+|-)/, 1]
    end
  end

  ###########################################################################################
  #
  # AR Callbacks
  #
  ###########################################################################################

  def before_create
    if self.state.blank?
      self.state = Book::States[:ordered]
    end
  end

end

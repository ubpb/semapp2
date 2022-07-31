class Book < ApplicationRecord

  States = {
    :ordered  => "ordered",  # the book is marked to be added to the shelf
    :in_shelf => "in_shelf", # the book was placed in the sem app shelf
    :rejected => "rejected", # the book is marked to be removed from the shelf
    :deferred => "deferred"  # the book is deferred
  }.freeze

  # Relations
  belongs_to :sem_app
  belongs_to :creator,     :class_name => 'User', optional: true
  belongs_to :placeholder, :class_name => 'SemApp', optional: true

  # Validation
  validates_presence_of   :sem_app
  validates_presence_of   :ils_id
  validates_uniqueness_of :ils_id, :scope => :sem_app_id, :message => "Dieses Exemplar befindet sich bereits in Ihrem Seminarapparat."
  validates_presence_of   :title
  validates_presence_of   :author

  # Scopes
  scope :for_sem_app, lambda { |sem_app| where( :sem_app_id => sem_app.id ) }
  scope :ordered,     lambda { where( :state => Book::States[:ordered]  ) }
  scope :in_shelf,    lambda { where( :state => Book::States[:in_shelf] ) }
  scope :removed,     lambda { where( :state => Book::States[:rejected] ) }
  scope :deferred,    lambda { where( :state => Book::States[:deferred] ) }
  scope :ordered_by,  lambda { |*order| order( order.flatten.first || 'title DESC' ) }

  ###########################################################################################
  #
  # Public API
  #
  ###########################################################################################

  def ils_id_formated
    if self.ils_id.present?
      if self.ils_id.length > 9
        # Alma MMS ID
        self.ils_id
      else
        # For some strange reason the Aleph IDs are missing the leading zeros.
        self.ils_id&.to_s.rjust(9, '0')
      end
    end
  end

  def state=(value)
    if value.present? and States[value.to_sym].present?
      write_attribute(:state, States[value.to_sym])
    else
      write_attribute(:state, '')
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

  def reference_copy?
    reference_copy.present?
  end

  def author
    author = read_attribute(:author)

    # Cleanup z13 GND additions
    if author.present?
      author = author.gsub(/\(.+\)[0-9X]+/, "")
      author = author.gsub(/\d{4}-/, "")
      author = author.gsub(/\d{4}/, "")
      author = author.strip
    end

    author
  end

  ###########################################################################################
  #
  # Class Methods
  #
  ###########################################################################################

  def self.get_base_signature(signature)
    if signature.present?
      base_signature = signature[/(.+)(\(|\+|-).+/, 1]
      return base_signature.present? ? base_signature : signature
    end
  end

  def self.get_base_signature2(signature)
    if signature.present?
      base_signature = signature[/([a-z]+\d+)([\D].*)?/i, 1]
      return base_signature.present? ? base_signature : signature
    end
  end

  ###########################################################################################
  #
  # AR Callbacks
  #
  ###########################################################################################

  before_create :ensure_state

  def ensure_state
    if self.state.blank?
      self.state = Book::States[:ordered]
    end
  end

end

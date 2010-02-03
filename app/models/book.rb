# == Schema Information
# Schema version: 20091110135349
#
# Table name: books
#
#  id                     :integer         not null, primary key
#  sem_app_id             :integer         not null
#  ils_id                 :string(255)     not null
#  signature              :string(255)     not null
#  title                  :string(255)     not null
#  author                 :string(255)     not null
#  edition                :string(255)
#  place                  :string(255)
#  publisher              :string(255)
#  year                   :string(255)
#  isbn                   :string(255)
#  comment                :text
#  scheduled_for_addition :boolean         not null
#  scheduled_for_removal  :boolean         not null
#  created_at             :datetime
#  updated_at             :datetime
#

class Book < ActiveRecord::Base

  States = {
    :new      => "new",      # the book is marked to be added to the shelf
    :in_shelf => "in_shelf", # the book was placed in the sem app shelf
    :removed  => "removed",  # the book is marked to be removed from the shelf
    :deferred => "deferred"  # the book is deferred
  }.freeze

  # Relations
  belongs_to :sem_app

  # Validations
  validates_presence_of   :sem_app
  validates_presence_of   :ils_id
  validates_uniqueness_of :ils_id, :scope => :sem_app_id, :message => "Dieses Exemplar befindet sich bereits in Ihrem eSeminarapparat."
  validates_presence_of   :signature
  validates_presence_of   :title
  validates_presence_of   :author

  ###########################################################################################
  #
  # Public API
  #
  ###########################################################################################

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

  def base_signature
    Book.get_base_signature(signature)
  end

  ###########################################################################################
  #
  # Class Methods
  #
  ###########################################################################################

  def self.get_base_signature(signature)
    if signature.present?
      m = signature.match(/(.+)(\(|\+|-).*/)
      (m and m[1]) ? m[1] : signature
    end
  end

  ###########################################################################################
  #
  # AR Callbacks
  #
  ###########################################################################################

  def before_create
    if self.state.blank?
      self.state = Book::States[:new]
    end
  end

end

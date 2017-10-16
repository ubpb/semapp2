class SemApp < ActiveRecord::Base

  # Relations
  belongs_to :creator, :class_name => 'User'
  belongs_to :semester
  belongs_to :location

  has_one    :book_shelf, :dependent => :destroy, validate: true
  has_one    :book_shelf_ref, :dependent => :destroy
  has_many   :ownerships, :dependent => :destroy
  has_many   :owners, :through => :ownerships, :source => :user
  has_many   :books, -> {order("title desc")}, :dependent => :destroy
  has_many   :media, -> {includes(:instance, :file_attachments, :scanjob).order("position asc, instance_id asc")}, :dependent => :destroy
  has_many   :miless_passwords, :dependent => :destroy

  # Behavior
  accepts_nested_attributes_for :book_shelf, :allow_destroy => true, :reject_if => lambda {
    |attrs| attrs.all? { |k, v| v.blank? }
  }

  accepts_nested_attributes_for :book_shelf_ref, :allow_destroy => true, :reject_if => lambda {
    |attrs| attrs.all? { |k, v| v.blank? }
  }

  # Validation
  validates_presence_of   :creator
  validates_presence_of   :semester
  validates_presence_of   :location
  validates_presence_of   :title
  validates_presence_of   :tutors
  validates_presence_of   :shared_secret
  validates_acceptance_of :accepts_copyright

  # Scopes
  scope :from_current_semester, -> { where(semester_id: Semester.current.id) }
  scope :unapproved,            -> { where(approved: false) }
  scope :approved,              -> { where(approved: true) }
  scope :with_book_jobs,        -> { joins(:books).distinct.where( "books.state = '#{Book::States[:ordered]}' OR books.state = '#{Book::States[:rejected]}'" ) }
  scope :created_by,            ->(user) { where("creator_id = ?", user.id) }

  # Auto strip
  auto_strip_attributes :title, :tutors, :course_id, squish: true

  # Fulltext search
  include PgSearch
  pg_search_scope :search_by_title,       :against => :title,                                        :using => { :tsearch => { :prefix => true  } }
  pg_search_scope :search_by_tutors,      :against => :tutors,                                       :using => { :tsearch => { :prefix => true  } }
  pg_search_scope :search_by_slot_number, :associated_against => { :book_shelf => :slot_number    }, :using => { :tsearch => { :prefix => false } }
  pg_search_scope :search_by_ils_account, :associated_against => { :book_shelf => :ils_account    }, :using => { :tsearch => { :prefix => false } }
  pg_search_scope :search_by_owners,      :associated_against => { :owners     => [:name, :login] }, :using => { :tsearch => { :prefix => true  } }

  # virtual attributes
  attr_accessor :accepts_copyright

  #
  # revised public api
  #
  def add_ownership(user)
    Ownership.create(user: user, sem_app: self) unless owned_by?(user) || new_record?
  end

  def owned_by?(user)
    (user == self.creator) || owners.include?(user)
  end

  ###########################################################################################
  #
  # Public API
  #
  ###########################################################################################

  def full_title
    "#{self.title} (#{self.semester.title})"
  end

  def title
    title = self.read_attribute(:title)
    cid   = self.course_id
    (cid.present? && !title.include?(cid)) ? "#{title} (#{self.course_id})" : "#{title}"
  end

  def has_book_jobs?
    Book.for_sem_app(self).ordered.count > 0 or Book.for_sem_app(self).removed.count > 0
  end

  def book_by_ils_id(ils_id)
    Book.where( sem_app_id: self.id, ils_id: ils_id ).first
  end

  def generate_access_token
    self.access_token = SecureRandom.hex(16)
  end

  def generate_access_token!
    generate_access_token
    self.save!
  end

  def is_unlocked_in_session?(session)
    unlocks = session[:unlocked]
    unlocks.present? and unlocks[self.id.to_s] == true
  end

  def unlock_in_session(session)
    unlocks = session[:unlocked]
    unlocks = {} unless unlocks.present?
    unlocks[self.id.to_s] = true
    session[:unlocked] = unlocks
  end

  def lock_in_session(session)
    unlocks = session[:unlocked]
    unlocks.delete(self.id.to_s) if unlocks.present?
  end

  def is_from_current_semester?
    self.semester == Semester.current
  end

  def has_book_shelf?
    self.book_shelf.present?
  end

  def has_book_shelf_ref?
    self.book_shelf_ref.present?
  end

  def can_transit?
    self.semester != Semester.transit_target
  end

  def books_can_be_cloned_when_transit?
    (Semester.transit_target != Semester.current) && (self.semester == Semester.current)
  end

  def next_position(origin_id)
    position = 1

    if origin_id.present?
      origin_media = media.find_by(instance_id: origin_id)
      position     = origin_media.position if origin_media
    end

    return position
  end

end

class SemApp < ActiveRecord::Base

  # Relations
  belongs_to :creator, :class_name => 'User'
  belongs_to :semester
  belongs_to :location

  has_one    :book_shelf, :dependent => :destroy
  has_one    :book_shelf_ref, :dependent => :destroy
  has_many   :ownerships, :dependent => :destroy
  has_many   :owners, :through => :ownerships, :source => :user
  has_many   :books, -> {order("title desc")}, :dependent => :destroy
  has_many   :entries, -> {order("position asc")}, :dependent => :destroy
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

  #validates_uniqueness_of :course_id, :scope => :semester_id, :allow_nil => true, :allow_blank => false

  # Scopes
  scope :from_current_semester, lambda { where( semester_id: Semester.current.id ) }
  scope :ordered_by,  lambda { |*order| order( order.flatten.first || 'title DESC' ) }
  scope :unapproved, lambda { where( approved: false ) }
  scope :approved, lambda { where( approved: true ) }
  scope :with_book_jobs, lambda { includes( :books ).where( "books.state = '#{Book::States[:ordered]}' OR books.state = '#{Book::States[:rejected]}'" ) }

  # virtual attributes
  attr_accessor :accepts_copyright

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
    self.course_id.present? ? "#{title} (#{self.course_id})" : "#{title}"
  end

  def has_book_jobs?
    Book.for_sem_app(self).ordered.count > 0 or Book.for_sem_app(self).removed.count > 0
  end

  def book_by_ils_id(ils_id)
    Book.where( sem_app_id: self.id, ils_id: ils_id ).first
  end

  def add_ownership(user)
    unless self.new_record?
      unless has_ownership?(user)
        return Ownership.new(:user => user, :sem_app => self).save
      else
        return true
      end
    end
  end

  def has_ownership?(user)
    return true if self.creator == user

    user.ownerships.each do |os|
      return true if os.sem_app == self
    end
    return false
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

  def import_entries(source_sem_app)
    if source_sem_app.present? and source_sem_app.is_a?(SemApp)
      import_entries!(source_sem_app)
    end
  end

  def import_books(source_sem_app)
    if source_sem_app.present? and source_sem_app.is_a?(SemApp)
      import_books!(source_sem_app)
    end
  end

  def transit
    target_semester = Semester.find(SemApp2::TRANSIT_TARGET_SEMESTER_ID)
    #return if Semester.current == next_semester

    if target_semester.present?
      SemApp.transaction do
        clone = self.clone(:include => :book_shelf)
        clone.semester = target_semester
        clone.archived = false
        clone.approved = false
        clone.miless_derivate_id = nil
        clone.miless_document_id = nil
        clone.created_at = Time.now
        clone.updated_at = Time.now
        clone.save!

        clone.import_entries(self)
        clone.import_books(self)

        return clone
      end
    end
  end

  def next_position(origin_id)
    position = 1

    begin
      if origin_id.present?
        origin_entry = Entry.find(origin_id)
        position     = origin_entry.position + 1
      end
    rescue
      # nothing
    end

    return position
  end

  private

  def import_entries!(source_sem_app)
    source_sem_app.entries.each do |entry|
      instance = entry.instance
      clone = instance.clone(:exclude => [:file_attachments, :scanjob])

      instance.file_attachments.each do |a|
        path = a.file.path
        if File.exists?(path)
          attachment = FileAttachment.new(:file => File.new(path), :description => a.description, :scanjob => a.scanjob)
          attachment.file.instance_write(:file_name, a.file_file_name)
          clone.file_attachments << attachment
        end
      end

      clone.sem_app = self
      clone.save(validate: false)
    end
  end

  def import_books!(source_sem_app)
    source_sem_app.books.each do |book|
      clone = book.clone
      clone.sem_app = self
      clone.save(validate: false)
    end
  end

end

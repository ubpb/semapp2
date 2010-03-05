class SemApp < ActiveRecord::Base

  # Relations
  belongs_to :creator, :class_name => 'User'
  belongs_to :semester
  belongs_to :location

  has_one    :book_shelf, :dependent => :destroy
  has_many   :ownerships, :dependent => :destroy
  has_many   :owners, :through => :ownerships, :source => :user
  has_many   :books, :order => "title desc", :dependent => :destroy
  has_many   :entries, :order => "position asc", :dependent => :destroy
  has_many   :miless_passwords, :dependent => :destroy

  # Behavior
  accepts_nested_attributes_for :book_shelf, :allow_destroy => true, :reject_if => lambda { 
    |attrs| attrs.all? { |k, v| v.blank? } 
  }

  # Validation
  validates_presence_of   :creator
  validates_presence_of   :semester
  validates_presence_of   :location
  validates_presence_of   :title
  validates_presence_of   :tutors
  validates_presence_of   :shared_secret
  
  validates_uniqueness_of :course_id, :scope => :semester_id, :allow_nil => true, :allow_blank => false

  ###########################################################################################
  #
  # Public API
  #
  ###########################################################################################

  def full_title
    "#{self.title} (#{self.semester.title})"
  end

  def has_book_jobs?
    Book.for_sem_app(self).ordered.count > 0 or Book.for_sem_app(self).removed.count > 0
  end

  def book_by_ils_id(ils_id)
    Book.find(
      :first,
      :conditions => {
        :sem_app_id => self.id,
        :ils_id     => ils_id
      })
  end

  def add_ownership(user)
    unless self.new_record?
      Ownership.new(:user => user, :sem_app => self).save
    end
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

  def is_from_current_semester?
    self.semester == Semester.current
  end

  def has_book_shelf?
    self.book_shelf != nil
  end

  def clone_entries(source_sem_app)
    if source_sem_app.present? and source_sem_app.is_a?(SemApp)
      source_sem_app.entries.each do |entry|
        clone = entry.clone(:exclude => [:file_attachments])

        entry.file_attachments.each do |a|
          path = a.file.path
          if File.exists?(path)
            attachment = FileAttachment.new(:file => File.new(path), :description => a.description, :scanjob => a.scanjob)
            attachment.file.instance_write(:file_name, a.file_file_name)
            clone.file_attachments << attachment
          end
        end
          
        clone.sem_app = self
        clone.save(false)
      end
      self.resync_positions
    end
  end

  def transit(semester)
    if semester.present? and semester.is_a?(Semester)
      SemApp.transaction do
        clone = self.clone
        clone.semester = semester
        clone.save!
      end
    end
  end

  def next_position(origin_id)
    position = 0

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

  def resync_positions
    Entry.transaction do
      entries = Entry.for_sem_app(self).ordered_by('position asc')
      if entries.present?
        entries.each_with_index { |entry, i| entry.update_attribute(:position, i+1) }
      end
    end
  end

  ###########################################################################################
  #
  # Override accessors
  #
  ###########################################################################################

  #
  # Make sure we convert empty values to nil, to make the database
  # unique constrain work properly.
  #
  def course_id=(value)
    write_attribute :course_id, (value.blank? ? nil : value)
  end
  
end

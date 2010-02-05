class SemApp < ActiveRecord::Base

  # Relations
  belongs_to :creator, :class_name => 'User'
  belongs_to :semester
  belongs_to :location

  has_one    :book_shelf
  has_many   :ownerships, :dependent => :destroy
  has_many   :owners, :through => :ownerships, :source => :user
  has_many   :books, :order => "title desc", :dependent => :destroy
  has_many   :entries, :order => "position asc", :dependent => :destroy

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
  
  validates_uniqueness_of :title,     :scope => :semester_id
  validates_uniqueness_of :course_id, :scope => :semester_id, :allow_nil => true, :allow_blank => false

  ###########################################################################################
  #
  # Public API
  #
  ###########################################################################################

  def has_book_jobs?
    Book.ordered.present? or Book.rejected.present?
  end

  def book_by_ils_id(ils_id)
    Book.find(
      :first,
      :conditions => {
        :sem_app_id => self.id,
        :ils_id     => ils_id
      })
  end

#  def media(user = nil)
#    if user.present? and self.is_editable_for?(user)
#      SemAppEntry.find(:all,
#        :order      => :position,
#        :conditions => ["sem_app_id = :sem_app_id", {:sem_app_id => self.id}]
#      )
#    else
#      SemAppEntry.find(:all,
#        :order      => :position,
#        :conditions => ["sem_app_id = :sem_app_id and (publish_on < :date or publish_on is null)", {:sem_app_id => self.id, :date => Time.new}]
#      )
#    end
#  end
#
#  def scanjobs
#    scanjobs = []
#    SemAppEntry.find(:all, :conditions => { :sem_app_id => id}, :order => "created_at DESC").each do |e|
#      if (e.class == SemAppMonographScanjobEntry or
#            e.class == SemAppArticleScanjobEntry or
#            e.class == SemAppCollectedArticleScanjobEntry)
#        scanjobs << e
#      end
#    end
#    return scanjobs
#  end

  def add_ownership(user)
    unless self.new_record?
      Ownership.new(:user => user, :sem_app => self).save
    end
  end

  def is_editable_for?(user)
    user and (user.is_admin? or (user.owns_sem_app?(self) and self.approved?))
  end
  alias_method :editable?, :is_editable_for?

  def is_unlocked_in_session?(session)
    unlocks = session[:unlockes]
    unlocks.present? and unlocks[self.id.to_s].present?
  end

  def unlock_in_session(session)
    session[:unlockes] = {self.id.to_s => true}
  end

  def is_from_current_semester?
    self.semester == Semester.current
  end

  def has_book_shelf?
    self.book_shelf != nil
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

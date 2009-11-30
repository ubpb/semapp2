# == Schema Information
# Schema version: 20091110135349
#
# Table name: sem_apps
#
#  id            :integer(4)      not null, primary key
#  creator_id    :integer(4)      not null
#  semester_id   :integer(4)      not null
#  location_id   :integer(4)      not null
#  approved      :boolean(1)      not null
#  title         :string(255)     not null
#  tutors        :text            default(""), not null
#  shared_secret :string(255)     not null
#  course_id     :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class SemApp < ActiveRecord::Base

  # Relations
  belongs_to :creator, :class_name => 'User'
  belongs_to :semester
  belongs_to :location
  has_one    :book_shelf
  has_many   :ownerships, :dependent => :destroy
  has_many   :owners,     :through   => :ownerships, :source => :user

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
  
  def books(options = {})
    unless options[:all]
      options = {
        :scheduled_for_addition => false,
        :scheduled_for_removal  => false
      }.merge(options)
    else
      options.delete(:all)
    end

    Book.find(:all, :conditions => options.merge!(:sem_app_id => id), :order => "created_at DESC")
  end

  def book_by_ils_id(ils_id)
    Book.find(
      :first,
      :conditions => {
        :sem_app_id => self.id,
        :ils_id     => ils_id
      })
  end

  def media
    SemAppEntry.find(
      :all,
      :include    => [:instance],
      :order      => :position,
      :conditions => ["sem_app_id = :sem_app_id", {
          :sem_app_id => id
        }])
  end

  def add_ownership(user)
    unless self.new_record?
      Ownership.new(:user => user, :sem_app => self).save
    end
  end

  def editable?
    User.current and (User.current.is_admin? or (User.current.owns_sem_app?(self) and self.approved?))
  end

  def is_editable?
    editable?
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

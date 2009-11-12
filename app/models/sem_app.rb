# == Schema Information
# Schema version: 20090831113245
#
# Table name: sem_apps
#
#  id              :integer(4)      not null, primary key
#  semester_id     :integer(4)      not null
#  location_id     :integer(4)      not null
#  active          :boolean(1)      not null
#  approved        :boolean(1)      not null
#  title           :string(255)     not null
#  course_id       :string(255)
#  tutors          :text            default(""), not null
#  shared_secret   :string(255)     not null
#  bid             :string(255)
#  ref             :string(255)
#  books_synced_at :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

class SemApp < ActiveRecord::Base

  # Relations
  belongs_to :creator, :class_name => 'User'
  belongs_to :semester
  belongs_to :location
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
  validates_uniqueness_of :bid,       :scope => :semester_id, :allow_nil => true, :allow_blank => false


  ###########################################################################################
  #
  # Public API
  #
  ###########################################################################################
  
  def books(options = {})
    options = {
      :scheduled_for_addition => false,
      :scheduled_for_removal  => false
    }.merge(options)

    Book.find(:all, :conditions => options.merge!(:sem_app_id => id), :order => "created_at DESC")
  end

  def media_entries
    SemAppEntry.find(
      :all,
      :include    => [:instance],
      :order      => :position,
      :conditions => ["sem_app_id = :sem_app_id AND instance_type <> :instance_type", {
          :sem_app_id    => id,
          :instance_type => 'SemAppBookEntry'
        }])
  end

  def add_ownership(user)
    unless self.new_record?
      Ownership.new(:user => user, :sem_app => self).save
    end
  end

  def editable?
    User.current and (User.current.is_admin? or User.current.owns_sem_app?(self))
  end

  def is_editable?
    editable?
  end

  ###########################################################################################
  #
  # Override accessors
  #
  ###########################################################################################

  def course_id=(value)
    write_attribute :course_id, (value.blank? ? nil : value)
  end

  def bid=(value)
    write_attribute :bid, (value.blank? ? nil : value)
  end

  def ref=(value)
    write_attribute :ref, (value.blank? ? nil : value)
  end

end

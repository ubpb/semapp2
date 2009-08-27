# == Schema Information
# Schema version: 20090710121016
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

  belongs_to :semester
  belongs_to :location

  has_many :ownerships, :dependent => :destroy
  has_many :owners, :through => :ownerships, :source => :user

  validates_presence_of   :semester
  validates_presence_of   :location
  validates_presence_of   :title
  validates_uniqueness_of :title, :scope => :semester_id
  validates_presence_of   :tutors
  validates_presence_of   :shared_secret
  validates_uniqueness_of :course_id, :scope => :semester_id, :allow_nil => true
  validates_uniqueness_of :bid,       :scope => :semester_id, :allow_nil => true

  def book_entries(options = {})
    options = {
      :all => false,
      :scheduled_for_addition => false,
      :scheduled_for_removal => false
    }.merge(options)

    if options[:all]
      SemAppEntry.find(
        :all,
        :include => [:instance],
        :joins => "INNER JOIN sem_app_book_entries ON sem_app_book_entries.id = sem_app_entries.instance_id",
        :conditions => ["sem_app_entries.sem_app_id = :sem_app_id AND sem_app_entries.instance_type = :instance_type", {
            :sem_app_id             => id,
            :instance_type          => "SemAppBookEntry"}])
    else
      SemAppEntry.find(
        :all,
        :include => [:instance],
        :joins => "INNER JOIN sem_app_book_entries ON sem_app_book_entries.id = sem_app_entries.instance_id",
        :conditions => ["sem_app_entries.sem_app_id = :sem_app_id AND sem_app_entries.instance_type = :instance_type AND " +
            "sem_app_book_entries.scheduled_for_addition = :scheduled_for_addition AND " +
            "sem_app_book_entries.scheduled_for_removal = :scheduled_for_removal", {
            :sem_app_id             => id,
            :instance_type          => "SemAppBookEntry",
            :scheduled_for_addition => options[:scheduled_for_addition],
            :scheduled_for_removal  => options[:scheduled_for_removal]}])
    end
  end

  def book_by_signature(signature)
    SemAppEntry.find(
        :first,
        :include => [:instance],
        :joins => "INNER JOIN sem_app_book_entries ON sem_app_book_entries.id = sem_app_entries.instance_id",
        :conditions => ["sem_app_entries.sem_app_id = :sem_app_id AND sem_app_entries.instance_type = :instance_type AND " +
            "sem_app_book_entries.signature = :signature", {
            :sem_app_id    => id,
            :instance_type => "SemAppBookEntry",
            :signature     => signature}])
  end

  def media_entries
    SemAppEntry.find(
      :all,
      :include => [:instance],
      :conditions => ["sem_app_id = :sem_app_id AND instance_type <> :instance_type",
        {:sem_app_id => id, :instance_type => 'SemAppBookEntry'}],
      :order => :position)
  end

  def add_ownership(user)
    Ownership.new(:user => user, :sem_app => self).save
  end

  def editable?
    User.current and (User.current.is_admin? or User.current.owns_sem_app?(self))
  end

  def course_id
    t = read_attribute(:course_id)
    t unless t.blank?
  end

  def course_id=(value)
    write_attribute :course_id, (value.blank? ? nil : value)
  end

  def bid
    t = read_attribute(:bid)
    t unless t.blank?
  end

  def bid=(value)
    write_attribute :bid, (value.blank? ? nil : value)
  end

  def ref
    t = read_attribute(:ref)
    t unless t.blank?
  end

  def ref=(value)
    write_attribute :ref, (value.blank? ? nil : value)
  end

end

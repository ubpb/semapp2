# encoding: utf-8

class Entry < ActiveRecord::Base

  # Realations
  belongs_to :sem_app
  belongs_to :creator, :class_name => 'User'
  has_many :file_attachments, :dependent => :destroy
  has_one :scanjob, :dependent => :destroy

  # Validation
  validates_presence_of :sem_app

  # Scopes
  named_scope :for_sem_app, lambda { |sem_app| { :conditions => { :sem_app_id => sem_app.id }, :include => [:file_attachments, :scanjob] } }
  named_scope :ordered_by,  lambda { |*order| { :order => order.flatten.first || 'position asc' } }

  #################################################################################
  #
  # Public API
  #
  #################################################################################

  def to_be_published
    self.publish_on.present? and self.publish_on >= Time.new
  end

  def instance
    nil unless self.id.present? or self.new_record?

    unless @instance.present?
      if instance_type.present?
        @instance = instance_type.find(self.id)
      end
    else
      @instance
    end
  end

  def instance_type
    nil unless self.id.present? or self.new_record?

    unless @instance_type
      sql = "select p.relname from #{self.class.name.tableize} s, pg_class p where s.id = #{self.id} and s.tableoid = p.oid"
      res = connection.execute(sql)
      if res[0]['relname'].present?
        @instance_type = res[0]['relname'].classify.constantize
      end
    else
      @instance_type
    end
  end

end
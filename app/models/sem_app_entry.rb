# == Schema Information
# Schema version: 20091110135349
#
# Table name: sem_app_entries
#
#  id         :integer         not null, primary key
#  sem_app_id :integer         not null
#  position   :integer
#  publish_on :datetime
#  created_at :datetime
#  updated_at :datetime
#

class SemAppEntry < ActiveRecord::Base

  ScanStates = {
    :scan_new         => "scan_new",
    :scan_in_progress => "scan_in_progress",
    :scan_deferred    => "scan_deferred"
  }.freeze

  belongs_to :sem_app
  acts_as_inheritance_root
  acts_as_list :scope => :sem_app

  validates_presence_of :sem_app

  def to_be_published
    self.publish_on.present? and self.publish_on >= Time.new
  end

  def editable?
    self.scan_state == SemAppEntry::ScanStates[:scan_new] or self.scan_state.blank?
  end

  def scan_state=(value)
    if value.present? and States[value.to_sym].present?
      self.write_attribute(:state, States[value.to_sym])
    end
  end

  def set_scan_state(value)
    if value.present? and States[value.to_sym].present?
      self.update_attribute(:state, States[value.to_sym])
    end
  end

  def before_create
    if self.scan_state.blank?
      if (self.class == SemAppMonographScanjobEntry or
         self.class == SemAppArticleScanjobEntry or
         self.class == SemAppCollectedArticleScanjobEntry)
        self.state = SemAppEntry::ScanStates[:scan_new]
      end
    end
  end

end

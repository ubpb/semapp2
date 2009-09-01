# == Schema Information
# Schema version: 20090831113245
#
# Table name: sem_app_entries
#
#  id            :integer(4)      not null, primary key
#  sem_app_id    :integer(4)      not null
#  instance_id   :integer(4)      not null
#  instance_type :string(255)     not null
#  position      :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#

class SemAppEntry < ActiveRecord::Base

  belongs_to :sem_app

  belongs_to :instance, :polymorphic => true

  acts_as_list :scope => :sem_app

end

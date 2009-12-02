# == Schema Information
# Schema version: 20091110135349
#
# Table name: sem_app_entries
#
#  id            :integer(4)      not null, primary key
#  sem_app_id    :integer(4)      not null
#  instance_id   :integer(4)      not null
#  instance_type :string(255)     not null
#  position      :integer(4)      default(0), not null
#  created_at    :datetime
#  updated_at    :datetime
#

class SemAppEntry < ActiveRecord::Base

  belongs_to :sem_app

  acts_as_list :scope => :sem_app

  def instance
    unless @instance.present?
      if relname.present?
        @instance = relname.classify.constantize.find(self.id)
      end
    else
      @instance
    end
  end
  
  def relname
    unless @relname
      sql = "select p.relname from #{SemAppEntry.name.tableize} s, pg_class p where s.id = #{self.id} and s.tableoid = p.oid"
      res = connection.execute(sql)
      if res[0]
        @relname = res[0]['relname']
      end
    else
      @relname
    end
  end

  def partial_name
    'sem_app_entries/' + self.instance.class.name.underscore
  end

  def form_partial_name(form_type = :edit)
    'sem_app_entries/' + self.instance.class.name.underscore.concat('_form_').concat(form_type.to_s)
  end
  
end

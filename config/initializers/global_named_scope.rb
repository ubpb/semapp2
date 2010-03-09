# encoding: utf-8

class ActiveRecord::Base
  named_scope :conditions, lambda { |*args| {:conditions => args} }
end

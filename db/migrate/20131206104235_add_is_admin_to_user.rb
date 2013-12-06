begin
  require 'authority'
rescue LoadError
end

class AddIsAdminToUser < ActiveRecord::Migration
  def admin_authority_name; 'ROLE_ADMIN'; end

  # migration local model to compensate missing model features
  class User < ActiveRecord::Base
    has_and_belongs_to_many :authorities
  end

  def up
    add_column :users, :is_admin, :boolean, default: false, null: false; User.reset_column_information

    User.all.each do |user|
      if defined?(user.authorities)
        user.update_attribute :is_admin, user.authorities.any? { |authority| authority.name == admin_authority_name }
      end
    end
  end

  def down
    remove_column :users, :is_admin
  end
end

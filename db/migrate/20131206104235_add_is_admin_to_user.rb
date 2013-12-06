begin
  require 'authority'
rescue LoadError
end


class AddIsAdminToUser < ActiveRecord::Migration
  def admin_authority_name; 'ROLE_ADMIN'; end

  def up
    add_column :users, :is_admin, :boolean, default: false, null: false; User.reset_column_information

    User.all.each do |user|
      if defined?(user.authorities)
        user.update_attribute :is_admin, user.authorities.any? { |authority| authority.name == admin_authority_name }
      end
    end
  end

  def down
    if defined?(Authority)
      User.all.each do |user|
        if user.is_admin
          unless user.authorities.any? { |authority| authority.name == admin_authority_name }
            user.authorities << Authority.find_by(name: admin_authority_name)
          end
        end
      end
    end

    remove_column :users, :is_admin
  end
end

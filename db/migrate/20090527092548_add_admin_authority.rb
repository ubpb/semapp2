class AddAdminAuthority < ActiveRecord::Migration
  def self.up
    Authority.new(:name => 'ROLE_ADMIN').save!
  end

  def self.down
    a = Authority.find_by_name('ROLE_ADMIN')
    a.destroy if a
  end
end

class AddAdminUser < ActiveRecord::Migration
  def self.up
    u = User.new(:login => 'admin', :email => 'admin@somedomain.tld')
    u.set_password('admin')
    u.save!
    u.authorities << Authority.find_by_name('ROLE_ADMIN')
  end

  def self.down
    u = User.find_by_login('admin')
    u.destroy if u
  end
end

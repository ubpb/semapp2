class PaToPd < ActiveRecord::Migration
  def up
    user = User.find_by(login: "PA10123456")
    user.login = "PD10123456"
    user.save!
  end
end

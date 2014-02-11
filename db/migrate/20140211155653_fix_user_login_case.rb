class FixUserLoginCase < ActiveRecord::Migration
  def up
    User.where("login LIKE 'ps%'").destroy_all
    User.where("login LIKE 'Ps%'").destroy_all
    User.where("login LIKE 'pa%'").destroy_all
    User.where("login LIKE 'Pa%'").destroy_all
    User.where("login LIKE 'PA12001136 '").destroy_all

    User.all.each do |user|
      user.login = user.login.upcase.strip
      user.save!(validate: false)
    end
  end
end

class DeleteWrongUsers < ActiveRecord::Migration
  def up
    User.where("login NOT ILIKE 'P%'").destroy_all
  end
end

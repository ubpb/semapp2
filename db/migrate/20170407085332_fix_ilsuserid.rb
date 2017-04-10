class FixIlsuserid < ActiveRecord::Migration
  def change
    # Add the ilsuserid column
    add_column :users, :ilsuserid, :string
    add_index  :users, :ilsuserid, unique: true

    # For every user try to get the ilsuserid for the login
    User.all.each do |user|
      aleph_user = Aleph::Connector.new.resolve_user(user.login)
      ilsuserid  = aleph_user&.id

      if ilsuserid.present?
        user.update_attributes(ilsuserid: ilsuserid)
        puts "Ok: Migrated user '#{user.login}' to '#{ilsuserid}'"
      else
        User.transaction(requires_new: true) do
          begin
            print "Error: No result found for user '#{user.login}'. Trying to delete user... "
            user.destroy
            print "SUCCESS\n"
          rescue ActiveRecord::InvalidForeignKey => e
            print "FAILED - user has still related sem apps.\n"
            raise ActiveRecord::Rollback
          end
        end
      end

      # De-stress Aleph
      sleep(0.1)
    end
  end
end

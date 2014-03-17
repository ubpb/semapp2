class CleanupIlsAccountIds < ActiveRecord::Migration
  def up
    BookShelf.all.each do |bs|
      if bs.ils_account.present?
        bs.ils_account = bs.ils_account
        bs.save(validate: false)
      end
    end
  end
end

class CleanupIlsAccountIds < ActiveRecord::Migration
  def change
    BookShelf.all.each do |bs|
      bs.ils_account = bs.ils_account
      bs.save(validate: false)
    end
  end
end

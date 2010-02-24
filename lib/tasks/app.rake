begin
  require 'highline/import'
rescue LoadError
  puts '######################################'
  puts '# Please install the highline gem.   #'
  puts '# $sudo gem install highline         #'
  puts '######################################'
end

namespace :app do

  #
  # Synchronize books
  #
  desc "Synchronize books"
  task(:sync_books => :environment) do
    adapter   = AlephSyncEngineAdapter.new
    engine    = SyncEngine.new(adapter)
    engine.sync
  end

  #
  # Import from Miless
  #
  desc "Miless Import Step 1 (Import all Sem App data)"
  task(:import_sem_apps => :environment) do
    SemApp.destroy_all
    UbdokImporter.new.import_sem_apps
  end

  desc "Miless Import Step 2 (Import shared secrets)"
  task(:import_rights => :environment) do
    UbdokRightsImporter.new.import_rights
  end

end

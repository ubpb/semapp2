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
    # TODO: make this configurable
    adapter   = AlephSyncEngineAdapter.new(:base_url => 'http://ubaleph.uni-paderborn.de/X', :library => 'pad50', :search_base => 'pad01')
    engine    = SyncEngine.new(adapter)
    engine.sync
  end

end

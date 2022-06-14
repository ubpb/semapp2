require 'highline/import'

namespace :app do

  #
  # Synchronize books
  #
  desc "Synchronize books"
  task(:sync_books => :environment) do
    adapter   = AlmaSyncEngineAdapter.new
    engine    = SyncEngine.new(adapter)
    engine.sync
  end

  desc "Synchronize books for a single Sem App"
  task(:sync_sem_app => :environment) do
    adapter   = AlmaSyncEngineAdapter.new
    engine    = SyncEngine.new(adapter)

    sem_app_id = ask("Sem App ID?")

    engine.sync_sem_app(SemApp.find(sem_app_id.to_i))
  end

  #
  # Synchronize books
  #
  desc "Upload scanjobs"
  task(:upload_scanjobs => :environment) do
    ScanjobUploader.new.upload_scanjobs!
  end

end

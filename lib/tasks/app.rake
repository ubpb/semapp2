# encoding: utf-8

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

  desc "Synchronize books for a single Sem App"
  task(:sync_sem_app => :environment) do
    adapter   = AlephSyncEngineAdapter.new
    engine    = SyncEngine.new(adapter)

    sem_app_id = ask("Sem App ID?")

    engine.sync_sem_app(SemApp.find(sem_app_id.to_i))
  end

  #
  # Synchronize books
  #
  desc "Upload scanjobs"
  task(:upload_scanjobs => :environment) do
    ScanjobUploader.new.upload_scanjobs
  end

  #
  # Import from Miless
  #
  desc "Miless Import Step 1 (Import all Sem App data)"
  task(:import_sem_apps => :environment) do
    UbdokImporter.new.import_sem_apps
  end

  desc "Miless Import Step 2 (Import shared secrets)"
  task(:import_rights => :environment) do
    UbdokRightsImporter.new.import_rights
  end

  #
  # Owner Info
  #
  desc "Print out a list of current owners"
  task(:owner_info => :environment) do
    apps = SemApp.find(:all, :conditions => {:semester_id => Semester.current})
    puts "=== Aktuelle Apparate ==="
    apps.map do |a|
      user = User.find(a.creator_id)
      puts "#{a.id}; #{a.title}; #{user}" if user.email
    end

    puts "\n=== Apparate OHNE Kontakt E-Mail==="
    apps.map do |a|
      user = User.find(a.creator_id)
      puts "#{a.id}; #{a.title}; #{user}" unless user.email
    end
  end
end

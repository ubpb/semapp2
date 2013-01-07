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
  # Info-Mail am Semesterende
  #
  desc "Sends an info mail to sem app owners"
  task(:info_mail => :environment) do
    apps = SemApp.where(semester_id: Semester.current).all
    @owner_info = {}
    apps.each do |a|
      creator = a.creator
      owner_info_for_user(creator, a)
      owners = a.owners
      owners.each {|o| owner_info_for_user(o, a)}
    end

    apps_with_at_least_one_email_contact = []

    puts "\n=== Mit E-Mail ==="
    @owner_info.keys.each do |u|
      if u.email.present?
        apps = @owner_info[u]

        puts "#{u.login} - #{u.email}"
        Notifications.sem_app_transit_notification(u, apps).deliver

        apps.each do |a|
          apps_with_at_least_one_email_contact << a
          puts "\t[#{a.id}] #{a.title}"
        end
      end
    end

    puts "\n=== OHNE E-Mail ==="
    @owner_info.keys.each do |u|
      if u.email.blank?
        apps = @owner_info[u]
        puts "#{u.login}"
        apps.each do |a|
          unless apps_with_at_least_one_email_contact.include?(a)
            puts "\t[#{a.id}] #{a.title}"
          end
        end
      end
    end
  end

  def owner_info_for_user(user, app)
    if @owner_info.include?(user)
      apps = @owner_info[user]
      apps << app
      @owner_info[user] = apps
    else
      @owner_info[user] = [app]
    end
  end

end

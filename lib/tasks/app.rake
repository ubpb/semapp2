require 'highline/import'

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
    ScanjobUploader.new.upload_scanjobs!
  end

  #
  # Resolve users
  #
  desc "Resolve / Update local users with Aleph"
  task(:resolve_users => :environment) do
    success = 0
    errors = 0

    User.all.each do |user|
      aleph_user = nil
      aleph_user = Aleph::Connector.new.resolve_user(user.login) if user.login.present?
      aleph_user = Aleph::Connector.new.resolve_user(user.ilsuserid) if user.ilsuserid.present? && aleph_user.nil?

      if aleph_user
        success += 1
        user.update_attributes!(
          login: aleph_user.login,
          ilsuserid: aleph_user.id,
          name: aleph_user.name,
          email: aleph_user.email
        )
        puts "OK: User '#{user.name.presence || 'n.a'} (#{user.id})' resolved and updated with login=#{aleph_user.login} and ilsuserid=#{aleph_user.ilsuserid}"
      else
        errors += 1
        puts "ERROR: User '#{user.name.presence || 'n.a'} (#{user.id})' can't be resolved using login=#{user.login.presence || 'n.a.'} or ilsuserid=#{user.ilsuserid.presence || 'n.a.'}"
      end

      sleep(0.3) # de-stress Aleph
    end

    puts "--------------"
    puts "Success: #{success}"
    puts "Errors: #{errors}"
  end

end

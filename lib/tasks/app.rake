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
        puts "OK: User '#{user.name.presence || 'n.a'} (#{user.id})' resolved and updated with login=#{aleph_user.login} and ilsuserid=#{aleph_user.id}"
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

  #
  # Migrate data from PG to mysql
  #
  desc "Migrate data from PG to mysql"
  task(:pg2mysql => :environment) do
    require "sequel"

    mysql_conn    = ask("MYSQL connection string?")
    mysql_db_name = ask("MYSQL db name?")
    postgres_conn = ask("POSTGRES connection string?")

    MYSQL    = Sequel.connect(mysql_conn)
    POSTGRES = Sequel.connect(postgres_conn)

    errors = 0

    MYSQL.run("SET FOREIGN_KEY_CHECKS=0;")
    MYSQL['SELECT table_name FROM information_schema.tables WHERE table_schema = ?', mysql_db_name].each do |row|
      table_name = row[:TABLE_NAME] || row[:table_name]
      print "Migrating table: #{table_name}\n"

      MYSQL.run("TRUNCATE TABLE #{table_name}")
      print "  [1] Cleaning target table: DONE\n"

      source_ds = POSTGRES[table_name.to_sym]
      target_ds = MYSQL[table_name.to_sym]
      print "  [2] Processing #{source_ds.count} record(s): "
      source_ds.all.each_slice(50000) do |rows|
        target_ds.multi_insert(rows)
      end
      print "DONE\n"

      valid = source_ds.count == target_ds.count
      errors += 1 unless valid
      print "  [3] Validating row count: #{valid ?  'SUCCESS' : 'FAILED'}\n"

      puts ""
    end
    MYSQL.run("SET FOREIGN_KEY_CHECKS=1;")

    if errors > 0
      puts "=> FINISHED. There has been #{errors} error(s) during migration."
    else
      puts "=> FINISHED. No errors!"
    end
  end

end

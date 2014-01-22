class FixSemAppWhitespace < ActiveRecord::Migration
  def up
    Rake::Task['app:fix:sem_app_whitespace'].invoke
  end
end

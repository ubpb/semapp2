class Entry < ActiveRecord::Base
  belongs_to :sem_app, :touch => true
  belongs_to :creator, :class_name => 'User'
  has_many :file_attachments, :dependent => :destroy
  has_one :scanjob, :dependent => :destroy
end

class TextEntry < Entry
  belongs_to :sem_app
  self.table_name = :text_entries
end

class ArticleEntry < Entry
  belongs_to :sem_app
  self.table_name = :article_entries
end

class CollectedArticleEntry < Entry
  belongs_to :sem_app
  self.table_name = :collected_article_entries
end

class MonographEntry < Entry
  belongs_to :sem_app
  self.table_name = :monograph_entries
end

class MilessFileEntry < Entry
  belongs_to :sem_app
  self.table_name = :miless_file_entries
end

class HeadlineEntry < Entry
  belongs_to :sem_app
  self.table_name = :headline_entries
end



class MigrateEntries < ActiveRecord::Migration

  disable_ddl_transaction!

  BATCH_SIZE = 1000

  def up
    Media.delete_all
    MediaText.delete_all
    MediaArticle.delete_all
    MediaCollectedArticle.delete_all
    MediaHeadline.delete_all
    MediaMonograph.delete_all

    process("TextEntry")
    process("HeadlineEntry")
    process("MonographEntry")
    process("ArticleEntry")
    process("CollectedArticleEntry")
    process("MilessFileEntry")
  end

  private

  def process(class_name)
    i     = 1
    clazz = class_name.classify.constantize
    count = clazz.count

    print "Processing #{count} records of type #{clazz}\n"
    clazz.find_in_batches(batch_size: BATCH_SIZE) do |batch|
      print "# #{i}..#{(i = i+BATCH_SIZE) - 1} "
      time = process_batch(batch)
      print "(#{time} sec.)\n"
    end
    print "\n"
  end

  def process_batch(batch)
    Benchmark.realtime do
      ActiveRecord::Base.transaction do
        batch.each do |entry|
          instance = case entry.class.name
          when "HeadlineEntry"         then MediaHeadline.new
          when "TextEntry"             then MediaText.new
          when "MonographEntry"        then MediaMonograph.new
          when "ArticleEntry"          then MediaArticle.new
          when "CollectedArticleEntry" then MediaCollectedArticle.new
          when "MilessFileEntry"       then MediaCollectedArticle.new
          else
            raise "Unhandled type #{entry.class.name}"
          end
          instance.assign_attributes(instance_attributes(entry, instance), without_protection: true)
          instance.save!(validate: false)

          ActiveRecord::Base.connection.execute(
            "ALTER SEQUENCE #{instance.class.name.tableize}_id_seq RESTART WITH #{instance.id + 1}"
          )

          media = Media.new(instance: instance)
          media.assign_attributes(media_attributes(entry, media), without_protection: true)
          media.save!(validate: false)

          ActiveRecord::Base.connection.execute(
            "ALTER SEQUENCE #{media.class.name.tableize}_id_seq RESTART WITH #{media.id + 1}"
          )

          # Relink file attachments
          ActiveRecord::Base.connection.execute <<-sql
            UPDATE file_attachments SET media_id=#{media.id} WHERE entry_id=#{entry.id};
          sql

          # Relink scan job
          ActiveRecord::Base.connection.execute <<-sql
            UPDATE scanjobs SET media_id=#{media.id} WHERE entry_id=#{entry.id};
          sql
        end
      end
    end
  end

  def instance_attributes(entry, instance)
    instance_attributes = instance.attributes
    entry.attributes.delete_if{ |a| !instance_attributes.include?(a) }
  end

  def media_attributes(entry, media)
    media_attributes = media.attributes
    entry.attributes.delete_if{ |a| !media_attributes.include?(a) }
  end

end

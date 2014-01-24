class FixSequences < ActiveRecord::Migration
  def up
    fix_sequence 'media',                    Media.order('id').last.id + 10
    fix_sequence 'media_headlines',          MediaHeadline.order('id').last.id + 10
    fix_sequence 'media_texts',              MediaText.order('id').last.id + 10
    fix_sequence 'media_monographs',         MediaMonograph.order('id').last.id + 10
    fix_sequence 'media_articles',           MediaArticle.order('id').last.id + 10
    fix_sequence 'media_collected_articles', MediaCollectedArticle.order('id').last.id + 10
  end

private

  def fix_sequence(table_name, value)
    ActiveRecord::Base.connection.execute(
      "ALTER SEQUENCE #{table_name}_id_seq RESTART WITH #{value}"
    )
  end

end

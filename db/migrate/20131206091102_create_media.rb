class CreateMedia < ActiveRecord::Migration
  def change
    #
    # Parent
    #
    create_table :media do |t|
      t.references  :instance,       index: true, polymorphic: true
      t.references  :sem_app,        index: true
      t.integer     :creator_id,     index: true
      t.integer     :position,       index: true
      t.string      :miless_entry_id
      t.timestamp   :publish_on
      t.timestamps
    end
    add_column :file_attachments, :media_id, :integer, index: true
    add_column :scanjobs,         :media_id, :integer, index: true

    #
    # Articles
    #
    create_table :media_articles do |t|
      t.text :author
      t.text :title
      t.text :subtitle
      t.text :journal
      t.text :place
      t.text :publisher
      t.text :volume
      t.text :year
      t.text :issue
      t.text :pages_from
      t.text :pages_to
      t.text :issn
      t.text :signature
      t.text :comment
      t.timestamps
    end

    #
    # Collected articles
    #
    create_table :media_collected_articles do |t|
      t.text :source_editor
      t.text :source_title
      t.text :source_subtitle
      t.text :source_year
      t.text :source_place
      t.text :source_publisher
      t.text :source_edition
      t.text :source_series_title
      t.text :source_series_volume
      t.text :source_signature
      t.text :source_isbn
      t.text :author
      t.text :title
      t.text :subtitle
      t.text :volume
      t.text :pages_from
      t.text :pages_to
      t.text :comment
      t.timestamps
    end

    #
    # Headline
    #
    create_table :media_headlines do |t|
      t.text    :headline
      t.integer :style, default: 0
      t.timestamps
    end

    #
    # Monograph
    #
    create_table :media_monographs do |t|
      t.text :author
      t.text :title
      t.text :subtitle
      t.text :year
      t.text :place
      t.text :publisher
      t.text :edition
      t.text :isbn
      t.text :signature
      t.text :comment
      t.timestamps
    end

    #
    # Text
    #
    create_table :media_texts do |t|
      t.text :text
      t.timestamps
    end
  end
end

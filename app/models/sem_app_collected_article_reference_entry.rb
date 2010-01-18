# == Schema Information
# Schema version: 20091110135349
#
# Table name: sem_app_collected_article_reference_entries
#
#  id                   :integer         not null, primary key
#  sem_app_id           :integer         not null
#  position             :integer
#  publish_on           :datetime
#  created_at           :datetime
#  updated_at           :datetime
#  source_editor        :string          not null
#  source_title         :text
#  source_subtitle      :text
#  source_year          :string
#  source_place         :string
#  source_publisher     :string
#  source_edition       :string
#  source_series_title  :text
#  source_series_volume :string
#  author               :string
#  title                :text
#  subtitle             :text
#  volume               :string
#  pages                :string
#  url                  :string
#

class SemAppCollectedArticleReferenceEntry < SemAppEntry
  set_table_name :sem_app_collected_article_reference_entries

  belongs_to :sem_app
  has_many   :attachments, :class_name => '::Attachment', :dependent => :destroy, :foreign_key => 'sem_app_entry_id'
  accepts_nested_attributes_for :attachments, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  validates_presence_of :source_editor
  validates_presence_of :source_title
  validates_presence_of :author
  validates_presence_of :title

  def to_s
    out  = ""
    out << author_to_s
    out << source_year_to_s
    out << title_to_s
    out << subtitle_to_s
    out << " In: "
    out << source_editor_to_s
    out << source_title_to_s
    out << source_subtitle_to_s
    out << source_place_to_s
    out << source_publisher_to_s
    out << source_edition_to_s
    out << source_series_title_and_volumne_to_s
    out << volume_to_s
    out << pages_to_s
    out.ends_with?(".") ? out : "#{out}."
  end

  private

  def source_editor_to_s
    source_editor.present? ? "#{source_editor.strip} (Hg.)" : "n.n. (Hg.)"
  end

  def source_title_to_s
    source_title.present? ? ": #{source_title.strip}" : ""
  end

  def source_subtitle_to_s
    source_subtitle.present? ? ". #{source_subtitle.strip}" : ""
  end

  def source_year_to_s
    source_year.present? ? " (#{source_year.strip})" : ""
  end

  def source_place_to_s
    source_place.present? ? ". #{source_place.strip}" : ""
  end

  def source_publisher_to_s
    source_publisher.present? ? ": #{source_publisher.strip}" : ""
  end

  def source_edition_to_s
    if source_edition.present?
      return (source_edition.to_i.to_s == source_edition) ? ". Aufl. #{source_edition.strip}" : ". #{source_edition.strip}"
    else
      return ""
    end
  end

  def source_series_title_and_volumne_to_s
    a  = []
    a << (source_series_title.present? ? source_series_title.strip : "n.n.")
    a << (source_series_volume.present? ? source_series_volume.strip : "")
    (a[0].present? or a[1].present?) ? " (#{a.join(', ')})" : ""
  end

  def author_to_s
    author.present? ? author.strip : "n.n."
  end

  def title_to_s
    title.present? ? ": #{title.strip}" : ""
  end

  def subtitle_to_s
    subtitle.present? ? ". #{subtitle.strip}" : ""
  end

  def volume_to_s
    volume.present? ? ", Bd. #{volume.strip}" : ""
  end
  
  def pages_to_s
    pages.present? ? ", S. #{pages.strip.gsub(/\s/, '')}" : ""
  end

end

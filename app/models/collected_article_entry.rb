class CollectedArticleEntry < Entry

  # Relation
  belongs_to :sem_app

  # Behavior
  self.table_name = :collected_article_entries

  # Validation
  validates_presence_of :source_year
  validates_presence_of :pages_from
  validates_presence_of :pages_to
  validates_numericality_of :pages_from, :only_integer => true
  validates_numericality_of :pages_to, :only_integer => true

  ######################################################################################################
  #
  # Public API
  #
  ######################################################################################################

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

  ######################################################################################################
  #
  # Private API
  #
  ######################################################################################################

  def source_editor_to_s
    source_editor.present? ? "#{source_editor.strip} (Hg.)" : ""
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
    a << (source_series_title.present? ? source_series_title.strip : "")
    a << (source_series_volume.present? ? source_series_volume.strip : "")
    (a[0].present? or a[1].present?) ? " (#{a.join(', ')})" : ""
  end

  def author_to_s
    author.present? ? author.strip : ""
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
    pages_from.present? and pages_to.present? ? ", S. #{pages_from}-#{pages_to}" : ""
  end

end

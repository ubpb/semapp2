class SemAppMonographReferenceEntry < SemAppEntry
  set_table_name :sem_app_monograph_reference_entries

  belongs_to :sem_app
  has_many   :attachments, :class_name => '::Attachment', :dependent => :destroy, :foreign_key => 'sem_app_entry_id'
  accepts_nested_attributes_for :attachments, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  validates_presence_of :author
  validates_presence_of :title

  def to_s
    out  = ""
    out << author_to_s
    out << year_to_s
    out << title_to_s
    out << subtitle_to_s
    out << edition_to_s
    out << place_to_s
    out << publisher_to_s
    out << isbn_to_s
    out.ends_with?(".") ? out : "#{out}."
  end

  private

  def author_to_s
    author.present? ? author.strip : "n.n."
  end

  def year_to_s
    year.present? ? " (#{year.strip})" : ""
  end

  def title_to_s
    title.present? ? ": #{title.strip}" : ""
  end

  def subtitle_to_s
    subtitle.present? ? ". #{subtitle.strip}" : ""
  end

  def edition_to_s
    if edition.present?
      return (edition.to_i.to_s == edition) ? ". Aufl. #{edition.strip}" : ". #{edition.strip}"
    else
      return ""
    end
  end

  def place_to_s
    if place.present?
      return ". #{place.strip}"
    else
      return ""
    end
  end

  def publisher_to_s
    if publisher.present?
      return ": #{publisher.strip}"
    else
      return ""
    end
  end

  def isbn_to_s
    if isbn.present?
      return ", ISBN #{isbn.strip}"
    else
      return ""
    end
  end

end

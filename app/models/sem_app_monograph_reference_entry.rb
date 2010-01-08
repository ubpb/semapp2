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
  end

  private

  def author_to_s
    author.present? ? author.strip : "n.n."
  end

  def year_to_s
    year.present? ? " (#{year.strip})" : ""
  end

  def title_to_s
    if title.present?
      return title.ends_with?(".") ? ": #{title.strip}" : ": #{title.strip}."
    else
      return ""
    end
  end

  def subtitle_to_s
    if subtitle.present?
      return subtitle.ends_with?(".") ? " #{subtitle.strip}" : " #{subtitle.strip}."
    else
      return ""
    end
  end

  def edition_to_s
    if edition.present?
      t = (edition.to_i.to_s == edition) ? " #{edition.strip} Aufl." : " #{edition.strip}"
      return t.ends_with?(".") ? t : "#{t}."
    else
      return ""
    end
  end

  def place_to_s
    if place.present?
      return " #{place.strip}"
    else
      return ""
    end
  end

  def publisher_to_s
    if publisher.present?
      return publisher.ends_with?(".") ? ": #{publisher.strip}" : ": #{publisher.strip}."
    else
      return ""
    end
  end

  def isbn_to_s
    if isbn.present?
      return isbn.ends_with?(".") ? " ISBN #{isbn.strip}" : " ISBN #{isbn.strip}."
    else
      return ""
    end
  end

end

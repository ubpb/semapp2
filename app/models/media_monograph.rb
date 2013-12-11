class MediaMonograph < ActiveRecord::Base

  # Behavior
  acts_as_media_instance

  # Validation
  validates :author, presence: true

  ######################################################################################################
  #
  # Public API
  #
  ######################################################################################################

  def title=(value)
    write_attribute :title, value.gsub("<", "").gsub(">", "")
  end

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

  ######################################################################################################
  #
  # Private API
  #
  ######################################################################################################

  def author_to_s
    author.present? ? author.strip : ""
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
    place.present? ? ". #{place.strip}" : ""
  end

  def publisher_to_s
    publisher.present? ? ": #{publisher.strip}" : ""
  end

  def isbn_to_s
    isbn.present? ? ", ISBN #{isbn.strip}" : ""
  end

end

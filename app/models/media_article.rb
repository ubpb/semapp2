class MediaArticle < ActiveRecord::Base

  # Behavior
  acts_as_media_instance

  # Validation
  validates :journal,    presence: true
  validates :year,       presence: true
  validates :pages_from, presence: true
  validates :pages_to,   presence: true

  ######################################################################################################
  #
  # Public API
  #
  ######################################################################################################

  def to_s
    out  = ""
    out << author_to_s
    out << year_to_s
    out << title_to_s
    out << subtitle_to_s
    out << journal_to_s
    out << volume_to_s
    out << issue_to_s
    out << pages_to_s
    out << issn_to_s
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

  def journal_to_s
    journal.present? ? ". In: #{journal.strip}" : ""
  end

  def volume_to_s
    volume.present? ? ", Jg. #{volume.strip}" : ""
  end

  def issue_to_s
    issue.present? ? ", H. #{issue.strip}" : ""
  end

  def pages_to_s
    pages_from.present? and pages_to.present? ? ", S. #{pages_from}-#{pages_to}" : ""
  end

  def issn_to_s
    issn.present? ? ", ISSN #{issn.strip}" : ""
  end

end

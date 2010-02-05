class ArticleEntry < Entry

  # Relation
  belongs_to :sem_app
  #has_many   :attachments, :class_name => '::Attachment', :dependent => :destroy, :foreign_key => 'entry_id'

  # Behavior
  set_table_name :article_entries
  #accepts_nested_attributes_for :attachments, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  # Validation
  validates_presence_of :author
  validates_presence_of :title

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
    pages.present? ? ", S. #{pages.strip.gsub(/\s/, '')}" : ""
  end

  def issn_to_s
    issn.present? ? ", ISSN #{issn.strip}" : ""
  end

end

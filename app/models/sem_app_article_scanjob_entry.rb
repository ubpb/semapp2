class SemAppArticleScanjobEntry < SemAppEntry
  set_table_name :sem_app_article_scanjob_entries

  belongs_to :sem_app
  has_many   :attachments, :class_name => '::Attachment', :dependent => :destroy, :foreign_key => 'sem_app_entry_id'
  accepts_nested_attributes_for :attachments, :allow_destroy => true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  validates_presence_of :author
  validates_presence_of :title
  validates_presence_of :signature
  validates_presence_of :pages
  validates_presence_of :journal
  validates_presence_of :volume
  validates_presence_of :year
  validates_presence_of :issue

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

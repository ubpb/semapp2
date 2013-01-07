# encoding: utf-8

class MilessFileEntry < Entry

  # Relation
  belongs_to :sem_app
  
  # Behavior
  self.table_name = :miless_file_entries
  
  ######################################################################################################
  #
  # Public API
  #
  ######################################################################################################
  
  def to_s
    to_source_ref
  end

  private

  ######################################################################################################
  #
  # Private API
  #
  ######################################################################################################

  def to_source_ref
    title  = attribute_or_nil(:title)
    author = attribute_or_nil(:author)
    pages  = pages_string(attribute_or_nil(:pages_from), attribute_or_nil(:pages_to))

    source_title     = attribute_or_nil(:source_title)
    source_editor    = attribute_or_nil(:source_editor)
    source_edition   = attribute_or_nil(:source_edition)
    source_year      = attribute_or_nil(:source_year)
    source_publisher = attribute_or_nil(:source_publisher)
    source_place     = attribute_or_nil(:source_place)
    source_ref       = attribute_or_nil(:source_ref)

    t0 = [author, title].compact.join(": ")
    t1 = [source_editor, source_title].compact.join(": ")
    t1 = "In. " + t1 if t1.present?
    t2 = [source_publisher, source_place].compact.join(":")
    t3 = [t2, source_year, source_edition, pages, source_ref].compact.join(", ")

    [t0, t1, t3].map{|e| t = e.strip; t.present? ? t : nil}.compact.join(". ")
  end

  def attribute_or_nil(attribute)
    v = self.read_attribute(attribute.to_sym)
    v.present? ? v : nil
  end

  def pages_string(pages_from, pages_to)
    if pages_from.present? and pages_to.present?
      "S. #{pages_from}-#{pages_to}"
    end
  end

end

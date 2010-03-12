# encoding: utf-8

#
# mysql --default-character-set=utf8 -u miless -pmiless miless -B -e "select ID from DOCUMENTS where types='a.6@@';" > semapps.txt
#

require 'net/http'
require 'xml'
require 'tempfile'

class UbdokImporter

  def initialize(options = {})
    @options = options.reverse_merge!(:creator_login => "PA06003114")
    @errors = 0
  end

  def import_sem_apps
    import_sem_apps!
    return true
  end

  def import_sem_app(id)
    begin
      import_sem_app!(id)
      return true
    rescue Exception => e
      puts "Error: " + e.message
      return false
    end
  end

  private

  def import_sem_apps!
    i = 0
    File.open(File.join(RAILS_ROOT, 'import', 'semapps.txt')).each do |line|
      if line.present? and line.strip!.present?
        import_sem_app!(line)
        i += 1
      end
    
      sleep(0.1)
    end
    puts "\n\n ==> #{i} imported successfully."
    puts "There were #{@errors.size} errors during import."

    return true
  end

  def import_sem_app!(document_id)
    begin
      document = load_document(document_id)
      raise "No such Sem App #{document_id}" if document.blank?

      derivate_id = get_derivate_id(document)
      raise "No derivate found for Sem App #{document_id}" if derivate_id.blank?

      derivate = load_derivate(derivate_id)
      raise "No derivate found #{derivate_id}" if derivate.blank?

      user     = User.find_by_login(@options[:creator_login])
      semester = Semester.find_by_id(calc_semester_id(get_document_modified_at(document)))
      location = Location.find_by_id(get_msa_id(derivate).first.to_i)

      sem_app = SemApp.create!(
        :miless_document_id => document_id,
        :miless_derivate_id => derivate_id,
        :creator            => user,
        :semester           => semester,
        :location           => location,
        :approved           => true,
        :title              => get_title(document),
        :tutors             => get_author(document),
        :shared_secret      => 'ubpad466'
      )

      puts "\nImporting Miless Document/Derivate: #{document_id}/#{derivate_id} => #{sem_app.id}"

      import_entries!(sem_app, document, derivate)
    rescue Exception => e
      @errors += 1
      puts "ERROR: #{e.message}"
    #ensure
    #  # FIXME: Quick hack to hopefully prevent segfaults with libxml-ruby
    #  sem_app  = nil
    #  document = nil
    #  derivate = nil
    #  GC.start
    end
  end

  def import_entries!(sem_app, document, derivate)
    derivate.find('/semesterapparat/entry').each_with_index do |entry, i|
      begin
        entry_id = attribute_from_node(entry, 'ID')
        raise "Entry without ID" if entry_id.blank?

        if headline_entry?(entry)
          create_headline(sem_app, entry, i)
        elsif file_entry?(entry)
          create_file(sem_app, entry, i, document)
        elsif text_entry?(entry)
          create_text(sem_app, entry, i)
        elsif book_entry?(entry)
          create_book(sem_app, entry, i)
        elsif html_entry?(entry)
          create_html(sem_app, entry, i)
        elsif link_entry?(entry)
          create_link(sem_app, entry, i)
        elsif article_scanjob_entry?(entry)
          create_article_scanjob(sem_app, entry, i, document)
        elsif collected_article_scanjob_entry?(entry)
          create_collected_article_scanjob(sem_app, entry, i, document)
        else
          puts "WARN: Unsupported or empty entry found."
        end
      rescue Exception => e
        puts e.backtrace
        @errors += 1
        if entry_id.present?
          puts "ERROR: #{entry_id}: #{e.message}"
        else
          puts "ERROR: #{e.message}"
        end
      end
    end
  end

  # ------------------------------------------------------------------------------
  # Entry Utils
  # ------------------------------------------------------------------------------

  def headline_entry?(node)
    content_from_node(node, 'headline').present?
  end

  def create_headline(sem_app, node, position)
    headline = content_from_node(node, 'headline')
    HeadlineEntry.create!(:sem_app => sem_app, :headline => headline, :position => position, :created_at => get_entry_created_at(node), :updated_at => get_entry_modified_at(node))
  end

  def text_entry?(node)
    content_from_node(node, 'freeText').present?
  end

  def create_text(sem_app, node, position)
    text = content_from_node(node, 'freeText')
    TextEntry.create!(:sem_app => sem_app, :text => text, :position => position, :created_at => get_entry_created_at(node), :updated_at => get_entry_modified_at(node))
  end

  def html_entry?(node)
    content_from_node(node, 'html').present?
  end

  def create_html(sem_app, node, position)
    text = content_from_node(node, 'html')
    TextEntry.create!(:sem_app => sem_app, :text => text, :position => position, :created_at => get_entry_created_at(node), :updated_at => get_entry_modified_at(node))
  end

  def link_entry?(node)
    content_from_node(node, 'webLink').present?
  end

  def create_link(sem_app, node, position)
    url   = content_from_node(node, 'webLink/url')
    label = content_from_node(node, 'webLink/label')

    content = '<a href="'+url+'">'+url+'</a>'
    if label.present?
      content << '<br/>' << label
    end

    TextEntry.create!(:sem_app => sem_app, :text => content, :position => position, :created_at => get_entry_created_at(node), :updated_at => get_entry_modified_at(node))
  end

  def book_entry?(node)
    content_from_node(node, 'book').present?
  end

  def create_book(sem_app, node, position)
    options = {}
    options[:sem_app]     = sem_app
    options[:position]    = position
    options[:created_at]  = get_entry_created_at(node)
    options[:updated_at] = get_entry_modified_at(node)
    options[:title]       = content_from_node(node, 'book/title')
    options[:author]      = content_from_node(node, 'book/author')
    options[:edition]     = content_from_node(node, 'book/edition')
    options[:place]       = content_from_node(node, 'book/place')
    options[:publisher]   = content_from_node(node, 'book/publisher')
    options[:year]        = content_from_node(node, 'book/year')
    options[:isbn]        = content_from_node(node, 'book/isbn')
    options[:signature]   = content_from_node(node, 'book/signature')
    options[:comment]     = content_from_node(node, 'book/comment')

    unless MonographEntry.new(options).save(false)
      raise "Failed to save an MonographEntry"
    end
  end

  def file_entry?(node)
    content_from_node(node, 'file').present?
  end

  def create_file(sem_app, node, position, document)
    derivate_id = get_derivate_id(document)
    entry_id    = attribute_from_node(node, 'ID')

    title            = content_from_node(node, 'file/chapter/title')
    author           = content_from_node(node, 'file/chapter/author')
    comment          = content_from_node(node, 'file/chapter/comment')

    source_title     = content_from_node(node, 'file/book/title')
    source_editor    = content_from_node(node, 'file/book/editor')
    source_edition   = content_from_node(node, 'file/book/edition')
    source_year      = content_from_node(node, 'file/book/year')
    source_publisher = content_from_node(node, 'file/book/publisher')
    source_place     = content_from_node(node, 'file/book/place')
    source_signature = content_from_node(node, 'file/book/signature')
    source_isbn      = content_from_node(node, 'file/book/isbn')
    pages_node = node.find_first('book/pages')
    if (pages_node)
      source_pages = "S. " << attribute_from_node(pages_node, 'from') << "-" << attribute_from_node(pages_node, 'to')
    end

    if title.present? and source_year.present?
      title << " (#{source_year})"
    end

    if source_edition.present?
      source_edition = ((source_edition.to_i.to_s == source_edition) ? " Auflage #{source_edition}" : " #{source_edition}")
    end

    source_publisher_and_place = [source_place, source_publisher].compact.join(": ")

    source_text = [source_editor, source_title, source_publisher_and_place, source_edition, source_pages].compact.join(". ")

    text = [title, author].compact.join(" / ")

    text << "." if text.present?

    if source_text.present?
      text << " In: " << source_text << "."
    end

    if source_isbn.present?
      text << "<br/>ISBN: " << source_isbn
    end

    if source_signature.present?
      text << "<br/>Signatur in der Bibliothek: " << source_signature
    end

    if comment.present?
      text << '<p style="font-style:italic">'+comment+'</p>'
    end

    # File Attachemnt?
    file_name = content_from_node(node, 'file/path')

    # Try to find a label
    label = content_from_node(node, 'file/label')
    text = label if text.blank? and label.present?
    text = file_name if file_name.present?
    text = "-" if text.blank?

    # Create the entry
    entry = TextEntry.create!(:sem_app => sem_app, :position => position, :text => text, :miless_entry_id => entry_id, :created_at => get_entry_created_at(node), :updated_at => get_entry_modified_at(node))

    # Attach the file
    attach_file(entry, derivate_id, entry_id, file_name)
  end

  def article_scanjob_entry?(node)
    content_from_node(node, 'article').present?
  end

  def create_article_scanjob(sem_app, node, position, document)
    derivate_id = get_derivate_id(document)
    entry_id    = attribute_from_node(node, 'ID')
    
    options = {}
    options[:miless_entry_id] = entry_id
    options[:sem_app]         = sem_app
    options[:position]        = position
    options[:created_at]      = get_entry_created_at(node)
    options[:updated_at]      = get_entry_modified_at(node)
    options[:title]           = content_from_node(node, 'article/title')
    options[:author]          = content_from_node(node, 'article/author')
    options[:comment]         = content_from_node(node, 'article/comment')
    options[:journal]         = content_from_node(node, 'article/journal/title')
    options[:place]           = content_from_node(node, 'article/journal/place')
    options[:publisher]       = content_from_node(node, 'article/journal/publisher')
    options[:signature]       = content_from_node(node, 'article/journal/signature')
    options[:volume]          = content_from_node(node, 'article/location/volume')
    options[:year]            = content_from_node(node, 'article/location/volume') # FIXME
    options[:issue]           = content_from_node(node, 'article/location/issue')
    pages_node = node.find_first('article/location/pages')
    if (pages_node)
      options[:pages_from] = attribute_from_node(pages_node, 'from')
      options[:pages_to]   = attribute_from_node(pages_node, 'to')
    end

    # Create the entry
    entry = ArticleEntry.new(options)
    if entry.save(false)
      file_name = content_from_node(node, 'article/text/path')
      if file_name.present?
        attach_file(entry, derivate_id, entry_id, file_name, true)
      else
        create_scanjob(entry, options[:pages_from], options[:pages_to], options[:signature], get_entry_created_at(node))
      end
    else
      raise "Failed to save an ArticleEntry"
    end
  end

  def collected_article_scanjob_entry?(node)
    content_from_node(node, 'chapter').present?
  end

  def create_collected_article_scanjob(sem_app, node, position, document)
    derivate_id = get_derivate_id(document)
    entry_id    = attribute_from_node(node, 'ID')
    
    options = {}
    options[:miless_entry_id]  = entry_id
    options[:sem_app]          = sem_app
    options[:position]         = position
    options[:created_at]       = get_entry_created_at(node)
    options[:updated_at]       = get_entry_modified_at(node)
    options[:title]            = content_from_node(node, 'chapter/title')
    options[:author]           = content_from_node(node, 'chapter/author')
    options[:comment]          = content_from_node(node, 'chapter/comment')
    options[:source_editor]    = content_from_node(node, 'chapter/book/editor')
    options[:source_title]     = content_from_node(node, 'chapter/book/title')
    options[:source_year]      = content_from_node(node, 'chapter/book/year')
    options[:source_place]     = content_from_node(node, 'chapter/book/place')
    options[:source_publisher] = content_from_node(node, 'chapter/book/publisher')
    options[:source_edition]   = content_from_node(node, 'chapter/book/edition')
    options[:source_signature] = content_from_node(node, 'chapter/book/signature')
    options[:source_isbn]      = content_from_node(node, 'chapter/book/isbn')
    pages_node = node.find_first('chapter/location/pages')
    if (pages_node)
      options[:pages_from] = attribute_from_node(pages_node, 'from')
      options[:pages_to]   = attribute_from_node(pages_node, 'to')
    end

    # Create the entry
    entry = CollectedArticleEntry.new(options)
    if entry.save(false)
      file_name = content_from_node(node, 'chapter/text/path')
      if file_name.present?
        attach_file(entry, derivate_id, entry_id, file_name, true)
      else
        create_scanjob(entry, options[:pages_from], options[:pages_to], options[:source_signature], get_entry_created_at(node))
      end
    else
      raise "Failed to save an CollectedArticleEntry"
    end
  end

  # ------------------------------------------------------------------------------
  # Common Utils
  # ------------------------------------------------------------------------------

  def create_scanjob(entry, pages_from, pages_to, signature, created_at)
    Scanjob.create!(:entry => entry, :pages_from => pages_from, :pages_to => pages_to, :signature => signature, :created_at => created_at)
  end

  def attach_file(entry, derivate_id, entry_id, file_name, scanjob = false)
    if file_name.present?
      file = load_file(derivate_id, entry_id, file_name)
      if file.present?
        attachment = FileAttachment.new(:file => file, :scanjob => scanjob)
        attachment.file.instance_write(:file_name, file_name)
        entry.file_attachments << attachment
      else
        raise "No such file #{file_name}"
      end
    else
      raise "No file name given"
    end
  end

  def load_document(id)
    url = "http://ubdok.uni-paderborn.de/servlets/DocumentServlet?id=#{id}&XSL.Style=xml"
    load_url(url).root
  end

  def load_derivate(id)
    url = "http://ubdok.uni-paderborn.de/servlets/DerivateServlet/Derivate-#{id}/index.msa?XSL.Style=xml"
    load_url(url).root
  end

  def get_document_id(node)
    attribute_from_node(node, 'ID')
  end

  def get_derivate_id(node)
    msa = node.find_first('derivates/derivate/files/file[@contenttype="msa"]')
    attribute_from_node(msa.parent.parent, 'ID') if msa.present?
  end

  def get_msa_id(node)
    attribute_from_node(node, 'ID')
  end
  
  def get_title(node)
    content_from_node(node, 'titles/title')
  end

  def get_author(node)
    content_from_node(node, 'creators/creator[@role="author"]/legalEntity/names/name')
  end

  def get_document_created_at(node)
    datestr = content_from_node(node, 'dates/date[@type="created"]')
    Date.strptime(datestr, '%d.%m.%Y')
  end

  def get_document_modified_at(node)
    datestr = content_from_node(node, 'dates/date[@type="modified"]')
    Date.strptime(datestr, '%d.%m.%Y')
  end

  def get_entry_created_at(node)
    datestr = attribute_from_node(node.find_first('dateTime[@type="created"]'), 'value')
    if datestr.present?
      Date.strptime(datestr, '%d.%m.%Y')
    else
      Date.now
    end
  end

  def get_entry_modified_at(node)
    datestr = attribute_from_node(node.find_first('dateTime[@type="modified"]'), 'value')
    if datestr.present?
      Date.strptime(datestr, '%d.%m.%Y')
    else
      Date.now
    end
  end

  def load_url(url)
    body = Net::HTTP.get_response(URI.parse(url)).body
    XML::Parser.string(body).parse
  end

  def load_file(derivate_id, entry_id, file_name)
    host          = 'ubdok.uni-paderborn.de'
    login_path    = '/servlets/LoginServlet'
    derivate_path = '/servlets/DerivateServlet/Derivate-'

    # Create http client
    http = Net::HTTP.new(host)

    # GET request -> so the host can set his cookies
    resp = http.get(login_path)
    cookie = resp.response['set-cookie']

    # GET request -> logging in
    resp, data = http.get(login_path + "?uid=SemApp&pwd=semapp466", {'Cookie' => cookie})

    # GET request -> download file
    file_url = derivate_path + "#{derivate_id}/#{entry_id}/#{file_name}"
    resp, data = http.get(file_url, {'Cookie' => cookie})

    # Write the stream to a temp file
    if (resp.code == "200" and data != nil)
      tempfile = Tempfile.new(file_name)
      tempfile.write(data)
      return tempfile
    else
      return nil
    end
  end

  def calc_semester_id(created_at)
    ss = {2010 => 1, 2009 => 3, 2008 => 5, 2007 => 7, 2006 => 9, 2005 => 11}
    ws = {2009 => 2, 2008 => 4, 2007 => 6, 2006 => 8, 2005 => 10}

    year  = created_at.year
    if (created_at >= Date.new(year, 4, 1) and created_at < Date.new(year, 9, 1))
      return ss[year]
    elsif (created_at >= Date.new(year, 9, 1) and created_at <= Date.new(year, 12, 31))
      return ws[year]
    elsif (created_at >= Date.new(year, 1, 1) and created_at < Date.new(year, 4, 1))
      return ws[year-1]
    else
      raise "this must not happen"
    end
  end

  def content_from_node(node, xpath = nil)
    raise "Node must be of type LibXML::XML::Document or LibXML::XML::Node" unless node.class == LibXML::XML::Document or node.class == LibXML::XML::Node
    return nil unless node.present?
    t = xpath ? node.find_first(xpath) : node
    return nil unless t.present?
    return nil unless t.content.present?
    c = t.content
    c.strip!
    c.present? ? c : nil
  end

  def attribute_from_node(node, attribute)
    raise "Node must be of type LibXML::XML::Document or LibXML::XML::Node" unless node.class == LibXML::XML::Document or node.class == LibXML::XML::Node
    return nil unless node.present?
    t = node.attributes[attribute]
    return nil unless t.present?
    c = t.to_s
    c.strip!
    c.present? ? c : nil
  end

end
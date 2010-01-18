require 'net/http'
require 'rexml/document'
require 'tempfile'

class UbdokImportController < ApplicationController

  def import_sem_apps
    return unless params[:ubdok_sem_apps_url] or params[:ubdok_sem_apps_url].empty?

    url = params[:ubdok_sem_apps_url].concat("?XSL.Style=xml")
    xml_data = Net::HTTP.get_response(URI.parse(url)).body
    doc = REXML::Document.new(xml_data)

    doc.elements.each('slots/slot') do |slot|
      status       = slot.attributes['status']
      next unless status == 'active'

      id           = slot.attributes['ID']
      aleph_tag    = slot.elements['aleph']
      document_tag = slot.elements['document']
      lecturer_tag = slot.elements['lecturer']
      org_unit_tag = slot.elements['orgUnit']

      semester = Semester.find(:first)
      sem_app = SemApp.new(:semester_id => semester.id, :title => document_tag.attributes['title'], :permalink => id)
      sem_app.save!
    end

    render :nothing => true
  end

  def import_sem_app
    if params[:ubdok_sem_app_url] and not params[:ubdok_sem_app_url].empty?
      @sem_app = SemApp.find(params[:sem_app_id])
      #@sem_app.sem_app_entries.each do |sem_app_entry|
      #  SemAppEntry.transaction do
      #    sem_app_entry.instance.destroy
      #    sem_app_entry.remove_from_list
      #  end
      #end
      #@sem_app.reload

      url = params[:ubdok_sem_app_url].concat("?XSL.Style=xml")
      xml_data = Net::HTTP.get_response(URI.parse(url)).body
      doc = REXML::Document.new(xml_data)

      derivate_id = url.match(/Derivate-(\d+)/)[1]

      @position = 0
      doc.elements.each('semesterapparat/entry') do |entry|
        entry.children.each do |child|
          if child.class == REXML::Element
            case child.name
            when 'headline'
              create_headline_entry(child.text)
            when 'text'
            when 'html'
              create_text_entry(child.text)
            when 'webLink'
              url = child.elements['url'] && child.elements['url'].text
              comment = child.elements['label'] && child.elements['label'].text
              create_weblink_entry(:url => url, :comment => comment)
            when 'file'
              entry_id = child.parent.attributes['ID']
              file_name = child.elements['path'] && child.elements['path'].text
              create_file_entry(:derivate_id => derivate_id, :entry_id => entry_id, :file_name => file_name)
            when 'chapter'
              create_text_entry("Scanjob Chapter TBD")
            when 'article'
              create_text_entry("Scanjob Article TBD")
            when 'book'
            #  options = {}
            #  options[:title]     = child.elements['title'] && child.elements['title'].text
            #  options[:author]    = child.elements['author'] && child.elements['author'].text
            #  options[:edition]   = child.elements['edition'] && child.elements['edition'].text
            #  options[:place]     = child.elements['place'] && child.elements['place'].text
            #  options[:publisher] = child.elements['publisher'] && child.elements['publisher'].text
            #  options[:year]      = child.elements['year'] && child.elements['year'].text
            #  options[:isbn]      = child.elements['isbn'] && child.elements['isbn'].text
            #  options[:signature] = child.elements['signature'] && child.elements['signature'].text
            #  options[:comment]   = child.elements['comment'] && child.elements['comment'].text
            #  create_book_entry(options)
            else
              logger.warn("Unsupported node: " + child.name)
            end
          end
        end
      end
    end

    redirect_to sem_app_url(@sem_app.id)
  end

  private

  def create_headline_entry(headline)
    SemAppEntry.transaction do
      headline_entry = SemAppHeadlineEntry.new(:headline => headline)
      entry = SemAppEntry.new(:sem_app => @sem_app, :instance => headline_entry, :position => @position)
      entry.save!
      @position = @position + 1
    end
  end

  def create_text_entry(text)
    SemAppEntry.transaction do
      text_entry = SemAppTextEntry.new(:body_text => text)
      entry = SemAppEntry.new(:sem_app => @sem_app, :instance => text_entry, :position => @position)
      entry.save!
      @position = @position + 1
    end
  end

  def create_weblink_entry(options = {})
    SemAppEntry.transaction do
      weblink_entry = SemAppWeblinkEntry.new(options)
      entry = SemAppEntry.new(:sem_app => @sem_app, :instance => weblink_entry, :position => @position)
      entry.save!
      @position = @position + 1
    end
  end

  def create_book_entry(options = {})
    options[:title] ||= 'Unbekannt'
    options[:author] ||= 'Unbekannt'
    
    SemAppEntry.transaction do
      book_entry = SemAppBookEntry.new(options)
      entry = SemAppEntry.new(:sem_app => @sem_app, :instance => book_entry, :position => @position)
      entry.save!
      @position = @position + 1
    end
  end

  def create_file_entry(options = {})
    return if not options[:derivate_id] or not options[:entry_id] or not options[:file_name]

    file = load_file(options[:derivate_id], options[:entry_id], options[:file_name])
    if file
      SemAppEntry.transaction do
        file_entry = SemAppFileEntry.new()

        file_attachment = SemAppFileAttachment.new(:attachment => file, :attachable => file_entry)
        # write the filename as we deal with temp files here
        file_attachment.attachment.instance_write(:file_name, options[:file_name])
        file_attachment.save!

        entry = SemAppEntry.new(:sem_app => @sem_app, :instance => file_entry, :position => @position)
        entry.save!
        @position = @position + 1
      end
    end
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
    end
  end

end

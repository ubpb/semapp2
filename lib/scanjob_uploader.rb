# encoding: utf-8

class ScanjobUploader

  def upload_scanjobs
    begin
      upload_scanjobs!
    rescue Exception => e
      puts "Error: #{e.message}"
      return false
    end

    return true
  end

  def upload_scanjobs!
    scanjob_files = File.join(RAILS_ROOT, 'data', 'scanjobs', 'scanjob-*.pdf')
    Dir.glob(scanjob_files).each do |filename|
      upload_scanjob(filename)
    end
  end

  private

  def upload_scanjob(filename)
    entry_id = filename[/scanjob-(\d+)/, 1]
    raise "Error: no Entry-ID found in filename." if entry_id.blank?

    entry = Entry.find(entry_id)
    file  = File.new(filename)

    processed_files = File.join(RAILS_ROOT, 'data', 'scanjobs', 'processed')
    FileUtils.mkdir(processed_files) unless File.exists?(processed_files)

    Entry.transaction do
      if entry.scanjob.present?
        attachment = FileAttachment.new(:file => file, :scanjob => true)
        attachment.file.instance_write(:file_name, File.basename(filename))
        entry.file_attachments << attachment

        entry.scanjob.destroy
      end

      FileUtils.mv(filename, processed_files)
    end
  end

end

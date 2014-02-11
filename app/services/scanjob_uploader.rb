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
    scanjob_files = File.join(Rails.root.to_s, 'data', 'scanjobs', 'scanjob-*.pdf')
    Dir.glob(scanjob_files).each do |filename|
      upload_scanjob(filename)
    end
  end

  private

  def upload_scanjob(filename)
    scanjob_id = filename[/scanjob-(\d+)/, 1]
    raise "Error: No Scanjob-ID found in filename." if scanjob_id.blank?

    scanjob = Scanjob.find(scanjob_id)
    entry = scanjob.entry
    file  = File.new(filename)

    processed_files = File.join(Rails.root.to_s, 'data', 'scanjobs', 'processed')
    FileUtils.mkdir(processed_files) unless File.exists?(processed_files)

    Entry.transaction do
      attachment = FileAttachment.new(:file => file, :description => scanjob.comment, :scanjob => true)
      attachment.file.instance_write(:file_name, File.basename(filename))
      entry.file_attachments << attachment
      scanjob.destroy
    end

    FileUtils.mv(filename, processed_files)
  end

end

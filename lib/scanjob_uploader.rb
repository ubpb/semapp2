# encoding: utf-8

class ScanjobUploader

  def upload_scanjobs
    upload_scanjobs!
  end

  private

  def upload_scanjobs!
    scanjob_files = File.join(RAILS_ROOT, 'data', 'scanjobs', '*')
    Dir.glob(scanjob_files).each do |filename|
      begin
        upload_scanjob(filename)
      rescue Exception => e
        puts "Error: #{e.message}"
      end
    end
  end

  def upload_scanjob(filename)
    entry_id = filename[/scanjob-(\d+)/, 1]
    raise "Error: no Entry-ID found in filename." if entry_id.blank?
    entry = Entry.find(entry_id)
    file  = File.new(filename)

    Entry.transaction do
      attachment = FileAttachment.new(:file => file, :scanjob => true)
      attachment.file.instance_write(:file_name, File.basename(filename))
      entry.file_attachments << attachment

      entry.scanjob.destroy

      File.delete(filename)
    end
  end

end

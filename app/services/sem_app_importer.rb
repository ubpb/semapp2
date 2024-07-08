class SemAppImporter

  IMPORT_PATH = "#{Rails.root}/tmp/imports".freeze

  def initialize(sem_app, import_file)
    @sem_app     = sem_app
    @import_file = import_file

    FileUtils.mkdir_p(IMPORT_PATH)
  end

  def import!
    unzip do |destination|
      SemApp.transaction do
        # @sem_app.media.delete_all
        process_import!(destination)
      end
    end
  end

private

  def unzip(&block)
    destination = Dir.mktmpdir(nil, IMPORT_PATH)

    Zip::File.open(@import_file) do |zipfile|
      zipfile.each do |entry|
        next unless entry.file?

        path = File.join(destination, normalized_entry_path(entry))
        FileUtils.mkdir_p(File.dirname(path))

        zipfile.extract(entry, path) unless File.exist?(path)
      end
    end

    yield(destination)
  ensure
    FileUtils.remove_entry(destination)
  end

  def normalized_entry_path(entry)
    entry.name.gsub('export/', '')
  end

  def process_import!(destination)
    manifest_file = File.join(destination, 'MANIFEST')

    begin
      contents = File.open(manifest_file, "rb") { |io| io.read }
      manifest = ActiveSupport::JSON.decode(contents)

      (manifest["export"]["media"] || []).each do |media_data|
        instance = process_instance!(media_data)
        media    = process_media!(media_data, instance)

        (media_data["file_attachments"] || []).each do |attachment_data|
          process_media_attachments(attachment_data, media, destination)
        end
      end

    rescue
      raise SemAppImporterError.new
    end
  end

  def process_instance!(media_data)
    instance_data = media_data["instance"]
    instance      = media_data["instance_type"].constantize.new

    instance.assign_attributes(instance_attributes(instance_data))
    instance.save!(validate: false)

    instance
  end

  def process_media!(media_data, instance)
    media = Media.new(instance: instance, sem_app: @sem_app, position: last_position + 1)
    media.assign_attributes(media_attributes(media_data))
    media.save!(validate: false)

    media
  end

  def process_media_attachments(attachment_data, media, destination)
    orig_id      = attachment_data["id"]
    filename     = attachment_data["file_file_name"]
    zip_filename = File.join(destination, "#{orig_id}_#{filename}")
    file         = File.new(zip_filename)

    attachment = FileAttachment.new(media: media, file: file)
    attachment.assign_attributes(file_attachment_attributes(attachment_data))
    attachment.save!(validate: false)

    attachment
  end

  def last_position
    @sem_app.media.reorder('position').last.try(:position).presence || 0
  end

  def media_attributes(media_data)
    {}
  end

  def instance_attributes(instance_data)
    instance_data.except("id")
  end

  def file_attachment_attributes(file_attachment_data)
    file_attachment_data.slice("description", "scanjob")
  end

end

class SemAppImporterError < RuntimeError ; end

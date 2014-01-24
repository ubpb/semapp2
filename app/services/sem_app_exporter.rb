require 'zip/filesystem'

class SemAppExporter

  EXPORT_PATH = "#{Rails.root}/tmp/exports".freeze

  def initialize(sem_app)
    @sem_app = sem_app

    FileUtils.mkdir_p(EXPORT_PATH)
  end

  def export!
    zip("#{EXPORT_PATH}/#{@sem_app.id}")
  end

private

  def zip(filename, &block)
    File.delete(filename) if File.exists?(filename)

    Zip::File.open(filename, Zip::File::CREATE) do |zipfile|
      zipfile.dir.mkdir("export")

      zip_manifest(zipfile)
      zip_file_attachments(zipfile)
    end

    filename
  end

  def zip_file_attachments(zipfile)
    @sem_app.media.each do |media|
      if media.file_attachments.present?
        media.file_attachments.each do |file_attachment|
          filename = file_attachment.file_file_name
          path     = file_attachment.file.path
          zipfile.add("export/#{file_attachment.id}_#{filename}", path) rescue true
        end
      end
    end
  end

  def zip_manifest(zipfile)
    zipfile.file.open("export/MANIFEST", "w") { |f| f.write(manifest) }
  end

  def manifest
    Jbuilder.encode do |json|
      json.export do
        json.created_at Time.zone.now

        json.sem_app do
          json.title @sem_app.title
        end

        json.media @sem_app.media do |media|
          json.id            media.id
          json.position      media.position
          json.instance_type media.instance_type
          json.instance_id   media.instance_id

          if media.file_attachments.present?
            json.file_attachments media.file_attachments
          end

          json.instance media.instance
        end
      end
    end
  end

end

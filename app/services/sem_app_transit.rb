class SemAppTransit

  def initialize(source_sem_app, target_semester, import_books: true, import_media: true)
    @source_sem_app  = source_sem_app
    @target_semester = target_semester
    @import_books    = import_books
    @import_media    = import_media
  end

  def transit!
    SemApp.transaction do
      target_sem_app = @source_sem_app.dup(include: :book_shelf, validate: false)

      import_basics!(target_sem_app)
      import_books!(target_sem_app) if @import_books
      import_media!(target_sem_app) if @import_media

      return target_sem_app
    end
  end

private

  def import_basics!(target_sem_app)
    target_sem_app.semester           = @target_semester
    target_sem_app.archived           = false
    target_sem_app.approved           = true # TODO
    target_sem_app.miless_derivate_id = nil
    target_sem_app.miless_document_id = nil
    target_sem_app.created_at         = Time.now
    target_sem_app.updated_at         = Time.now

    target_sem_app.save!(validate: false)
    target_sem_app
  end

  def import_books!(target_sem_app)
    @source_sem_app.books.each do |book|
      clone = book.dup
      clone.sem_app = target_sem_app
      clone.save!(validate: false)
    end

    target_sem_app
  end

  def import_media!(target_sem_app)
    @source_sem_app.media.each do |media|
      clone = media.dup(include: :instance, validate: false)

      clone.sem_app          = target_sem_app
      clone.file_attachments = media_file_attachments(media)

      clone.save!(validate: false)
    end

    target_sem_app
  end

  def media_file_attachments(media)
    media.file_attachments.map do |a|
      path = a.file.path

      if File.exists?(path)
        attachment = FileAttachment.new(
          file: File.new(path),
          description: a.description,
          scanjob: a.scanjob
        )
        attachment.file.instance_write(:file_name, a.file_file_name)
        attachment
      end
    end.compact
  end

end

class SemAppCloner

  def initialize(source_sem_app, target_sem_app, clone_books: true, clone_media: true, exclude_book_ids: [])
    @source_sem_app   = source_sem_app
    @target_sem_app   = target_sem_app
    @clone_books      = clone_books
    @clone_media      = clone_media
    @exclude_book_ids = exclude_book_ids
  end

  def clone!
    SemApp.transaction do
      clone_books! if @clone_books
      clone_media! if @clone_media
    end
  end

private

  def clone_books!
    if @source_sem_app.books_can_be_cloned_when_transit?
      # Clone books
      @source_sem_app.books.each do |book|
        next if @exclude_book_ids.include?(book.id)

        clone = book.dup
        clone.sem_app = @target_sem_app
        clone.save!(validate: false)
      end
    else
      # Reorder books
      @source_sem_app.books.in_shelf.each do |book|
        next if @exclude_book_ids.include?(book.id)

        clone = book.dup
        clone.sem_app = @target_sem_app
        clone.reference_copy = nil
        clone.placeholder = nil
        clone.state = :ordered
        clone.save!(validate: false)
      end
    end
  end

  def clone_media!
    @source_sem_app.media.each do |media|
      clone = media.deep_clone(include: :instance, validate: false)

      clone.sem_app          = @target_sem_app
      clone.file_attachments = media_file_attachments(media)

      clone.save!(validate: false)
    end
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

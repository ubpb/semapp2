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

      cloner = SemAppCloner.new(@source_sem_app, target_sem_app, clone_books: @import_books, clone_media: @import_media)
      cloner.clone!

      return target_sem_app
    end
  end

private

  def import_basics!(target_sem_app)
    target_sem_app.semester           = @target_semester
    target_sem_app.approved           = false
    target_sem_app.miless_derivate_id = nil
    target_sem_app.miless_document_id = nil
    target_sem_app.created_at         = Time.now
    target_sem_app.updated_at         = Time.now

    target_sem_app.save!(validate: false)
    target_sem_app
  end

end

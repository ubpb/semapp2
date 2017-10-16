class SemAppTransit

  def initialize(source_sem_app, target_semester, exclude_book_ids: [])
    @source_sem_app   = source_sem_app
    @target_semester  = target_semester
    @exclude_book_ids = exclude_book_ids
  end

  def transit!
    SemApp.transaction do
      target_sem_app = if @source_sem_app.books_can_be_cloned_when_transit?
        @source_sem_app.deep_clone(include: :book_shelf, validate: false)
      else
        @source_sem_app.deep_clone(validate: false)
      end

      import_basics!(target_sem_app)

      cloner = SemAppCloner.new(
        @source_sem_app,
        target_sem_app,
        clone_books: true,
        clone_media: true,
        exclude_book_ids: @exclude_book_ids
      )
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
    target_sem_app.generate_access_token

    target_sem_app.save!(validate: false)
    target_sem_app
  end

end

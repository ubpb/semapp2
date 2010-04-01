class BookSweeper < ActionController::Caching::Sweeper

  observe Book

  def before_update(object)
    expire_cache_for(object)
  end

  def before_destroy(object)
    expire_cache_for(object)
  end

  private

  def expire_cache_for(object)
    if object.present? and object.cache_key.present?
      expire_fragment(object.cache_key)
    end
  end

end
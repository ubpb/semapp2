class SemAppsFilter

  FILTERS = [
    :slot_number,
    :title,
    :tutors,
    :owners,
    :location_id,
    :semester_id,
    :ils_account,
    :approved,
    :unapproved,
    :book_jobs
  ].freeze

  attr_accessor *FILTERS


  class << self

    def set_filter_in_session(session, filters, index)
      filters        = filters.presence
      session[index] = filters
      self.new(filters)
    end

    def get_filter_from_session(session, index)
      self.new(session[index].presence)
    end

  end


  def initialize(filters = {})
    @fulltext_filter = false
    self.filter_attributes = filters
  end

  def filter_attributes=(filters)
    filters = ActiveSupport::HashWithIndifferentAccess.new(filters.presence)

    @slot_number = filters[:slot_number].presence
    @title       = filters[:title].presence
    @tutors      = filters[:tutors].presence
    @owners      = filters[:owners].presence
    @location_id = filters[:location_id].presence
    @semester_id = filters[:semester_id].presence
    @ils_account = filters[:ils_account].presence
    @approved    = filters[:approved].presence
    @unapproved  = filters[:unapproved].presence
    @book_jobs   = filters[:book_jobs].presence
  end

  def filter_attributes
    FILTERS.inject(ActiveSupport::HashWithIndifferentAccess.new) do |r, f|
      r[f] = self.instance_variable_get("@#{f}")
      r
    end
  end

  def filtered
    scope = SemApp.all

    scope = filter_by_slot_number(scope)
    scope = filter_by_title(scope)
    scope = filter_by_tutors(scope)
    scope = filter_by_owners(scope)
    scope = filter_by_location_id(scope)
    scope = filter_by_semester_id(scope)
    scope = filter_by_ils_account(scope)
    scope = filter_by_approved(scope)
    scope = filter_by_unapproved(scope)
    scope = filter_by_book_jobs(scope)

    scope = default_order(scope)

    scope
  end

  def filtered?(except: [])
    except = [*except]
    FILTERS.reject{|f| except.include?(f) }.any?{ |f| self.instance_variable_get("@#{f}").present? }
  end

private

  def filtered_by_some_fulltext_filter?
    @fulltext_filter == true
  end

  def filter_by_slot_number(scope)
    @fulltext_filter = true
    @slot_number ? scope.search_by_slot_number(@slot_number) : scope
  end

  def filter_by_title(scope)
    @fulltext_filter = true
    @title ? scope.search_by_title(@title) : scope
  end

  def filter_by_tutors(scope)
    @fulltext_filter = true
    @tutors ? scope.search_by_tutors(@tutors) : scope
  end

  def filter_by_owners(scope)
    @fulltext_filter = true
    @owners ? scope.search_by_owners(@owners) : scope
  end

  def filter_by_location_id(scope)
    @location_id ? scope.where("location_id = ?", @location_id) : scope
  end

  def filter_by_semester_id(scope)
    @semester_id ? scope.where("semester_id = ?", @semester_id) : scope
  end

  def filter_by_ils_account(scope)
    @fulltext_filter = true
    @ils_account ? scope.search_by_ils_account(@ils_account) : scope
  end

  def filter_by_approved(scope)
    @approved ? scope.approved : scope
  end

  def filter_by_unapproved(scope)
    @unapproved ? scope.unapproved : scope
  end

  def filter_by_book_jobs(scope)
    @book_jobs ? scope.with_book_jobs : scope
  end

  def default_order(scope)
    #
    # FIXME: We can not order by pg_search_rank when using two or more
    # pg_search scopes. That will result in an ambiguous pg_search_rank.
    # There is no known workaround at the moment. Also see https://github.com/Casecommons/pg_search/issues/1
    #

    #if filtered_by_some_fulltext_filter?
    #  scope.reorder("pg_search_rank desc")
    #else
    scope.joins(:semester).reorder("semesters.position asc, sem_apps.title asc")
    #end
  end

end

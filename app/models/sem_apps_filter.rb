class SemAppsFilter

  FILTERS = [
    :slot_number,
    :title,
    :tutors,
    :creator,
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
    self.filter_attributes = filters
  end

  def filter_attributes=(filters)
    if filters && filters.is_a?(ActionController::Parameters)
      filters = filters.permit(
        :slot_number, :title, :tutors, :creator, :location_id, :semester_id, :ils_account, :approved, :unapproved, :book_jobs
      )
    end

    filters = ActiveSupport::HashWithIndifferentAccess.new(filters.presence)

    @slot_number = filters[:slot_number].presence
    @title       = filters[:title].presence
    @tutors      = filters[:tutors].presence
    @creator     = filters[:creator].presence
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
    scope = SemApp.joins(:semester, :creator).includes(:book_shelf)

    scope = filter_by_slot_number(scope) if @slot_number
    scope = filter_by_title(scope) if @title
    scope = filter_by_tutors(scope) if @tutors
    scope = filter_by_creator(scope) if @creator
    scope = filter_by_location_id(scope) if @location_id
    scope = filter_by_semester_id(scope) if @semester_id
    scope = filter_by_ils_account(scope) if @ils_account
    scope = filter_by_approved(scope) if @approved
    scope = filter_by_unapproved(scope) if @unapproved
    scope = filter_by_book_jobs(scope) if @book_jobs

    scope = default_order(scope)

    scope
  end

  def filtered?(except: [])
    except = [*except]
    FILTERS.reject{|f| except.include?(f) }.any?{ |f| self.instance_variable_get("@#{f}").present? }
  end

private

  def filter_by_slot_number(scope)
    @slot_number ? scope.joins(:book_shelf).where(book_shelves: {slot_number: @slot_number}) : scope
  end

  def filter_by_title(scope)
    if @title
      tokens(@title).each do |token|
        scope = scope.where("sem_apps.title like ?", "%#{token}%")
      end
    end

    scope
  end

  def filter_by_tutors(scope)
    if @tutors
      tokens(@tutors).each do |token|
        scope = scope.where("sem_apps.tutors like ?", "%#{token}%")
      end
    end

    scope
  end

  def filter_by_creator(scope)
    if @creator
      like_token = @creator.gsub('%', '\%')
      scope = scope.where("users.name like :like_token or users.login = :token or users.ilsuserid = :token", like_token: "%#{like_token}%", token: @creator)
    end

    scope
  end

  def filter_by_location_id(scope)
    @location_id ? scope.where("location_id = ?", @location_id) : scope
  end

  def filter_by_semester_id(scope)
    @semester_id ? scope.where("semester_id = ?", @semester_id) : scope
  end

  def filter_by_ils_account(scope)
    @ils_account ? scope.joins(:book_shelf).where(book_shelves: {ils_account: @ils_account}) : scope
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
    scope.reorder("semesters.position asc, sem_apps.title asc")
  end

  def tokens(string_value)
    string_value.gsub('%', '\%').split(" ")
  end

end

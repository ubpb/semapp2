class SemAppsFilter

  attr_accessor :title, :tutors, :creator, :location, :semester, :ils_account, :slot_number, :unapproved_only, :bookjobs_only, :approved

  def initialize(filter = {})
    filter = {} unless filter

    @title           = filter[:title]         if filter[:title].present?
    @tutors          = filter[:tutors]        if filter[:tutors].present?
    @creator         = filter[:creator]       if filter[:creator].present?
    @location        = filter[:location].to_i if filter[:location].present?
    @semester        = filter[:semester].to_i if filter[:semester].present?
    @ils_account     = filter[:ils_account]   if filter[:ils_account].present?
    @slot_number     = filter[:slot_number]   if filter[:slot_number].present?
    @unapproved_only = filter[:only] == "unapproved"
    @bookjobs_only   = filter[:only] == "bookjobs"
    @approved        = filter[:approved]
  end

  def filtered
    sem_apps = SemApp.all
    sem_apps = sem_apps.includes( :books, :book_shelf )
    sem_apps = sem_apps.where "lower(sem_apps.title) LIKE ?", "%#{@title.downcase}%" unless @title.blank?
    sem_apps = sem_apps.where "lower(sem_apps.tutors) LIKE ?", "%#{@tutors.downcase}%" unless @tutors.blank?
    sem_apps = sem_apps.where "lower(users.name) LIKE ? OR lower(users.login) LIKE ?", "#{@creator.downcase}%", "#{@creator.downcase}%" unless @creator.blank?
    sem_apps = sem_apps.where "location_id = ?", "#{@location}" unless @location.blank?
    sem_apps = sem_apps.where "semester_id = ?", "#{@semester}" unless @semester.blank?
    sem_apps = sem_apps.where "lower(book_shelves.ils_account) like ?", "#{@ils_account.downcase}%" unless @ils_account.blank?
    sem_apps = sem_apps.where "lower(book_shelves.slot_number) = ?", "#{@slot_number.downcase}" unless @slot_number.blank?
    sem_apps = sem_apps.where "approved = ?", false if @unapproved_only
    sem_apps = sem_apps.where "approved = ?", @approved if @approved.present?
    sem_apps = sem_apps.where "books.state = ? OR books.state = ?", Book::States[:ordered], Book::States[:rejected] if @bookjobs_only
    sem_apps
  end

=begin
  def scope
    scope = SemApp.scoped({:include => [:books, :book_shelf]})
    scope = scope.conditions "lower(sem_apps.title) LIKE ?", "%#{@title.downcase}%" unless @title.blank?
    scope = scope.conditions "lower(sem_apps.tutors) LIKE ?", "%#{@tutors.downcase}%" unless @tutors.blank?
    scope = scope.conditions "lower(users.name) LIKE ? OR lower(users.login) LIKE ?", "#{@creator.downcase}%", "#{@creator.downcase}%" unless @creator.blank?
    scope = scope.conditions "location_id = ?", "#{@location}" unless @location.blank?
    scope = scope.conditions "semester_id = ?", "#{@semester}" unless @semester.blank?
    scope = scope.conditions "lower(book_shelves.ils_account) like ?", "#{@ils_account.downcase}%" unless @ils_account.blank?
    scope = scope.conditions "lower(book_shelves.slot_number) = ?", "#{@slot_number.downcase}" unless @slot_number.blank?
    scope = scope.conditions "approved = ?", false if @unapproved_only
    scope = scope.conditions "approved = ?", @approved if @approved.present?
    scope = scope.conditions "books.state = ? OR books.state = ?", Book::States[:ordered], Book::States[:rejected] if @bookjobs_only
    scope
  end
=end

  def filtered?(filters)
    filters.each do |f|
      return true if self.instance_variable_get("@#{f}").present?
    end
    false
  end

end

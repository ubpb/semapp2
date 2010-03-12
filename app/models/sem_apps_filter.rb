# encoding: utf-8

class SemAppsFilter

  attr_accessor :title, :tutors, :creator, :location, :semester, :unapproved_only, :bookjobs_only

  def initialize(filter = {})
    filter = {} unless filter

    @title           = filter[:title]         if filter[:title].present?
    @tutors          = filter[:tutors]        if filter[:tutors].present?
    @creator         = filter[:creator]       if filter[:creator].present?
    @location        = filter[:location].to_i if filter[:location].present?
    @semester        = filter[:semester].to_i if filter[:semester].present?
    @unapproved_only = filter[:only] == "unapproved"
    @bookjobs_only   = filter[:only] == "bookjobs"
  end

  def scope
    scope = SemApp.scoped({:include => [:books]})
    scope = scope.conditions "lower(sem_apps.title) LIKE ?", "%#{@title.downcase}%" unless @title.blank?
    scope = scope.conditions "lower(sem_apps.tutors) LIKE ?", "%#{@tutors.downcase}%" unless @tutors.blank?
    scope = scope.conditions "lower(users.name) LIKE ? OR lower(users.login) LIKE ?", "%#{@creator.downcase}%", "%#{@creator.downcase}%" unless @creator.blank?
    scope = scope.conditions "location_id = ?", "#{@location}" unless @location.blank?
    scope = scope.conditions "semester_id = ?", "#{@semester}" unless @semester.blank?
    scope = scope.conditions "approved = ?", false if @unapproved_only
    scope = scope.conditions "books.state = ? OR books.state = ?", Book::States[:ordered], Book::States[:rejected] if @bookjobs_only
    scope
  end

  def filtered?
    [@title, @tutors, @creator, @location, @semester, @unapproved_only, @bookjobs_only].any? {|f| f.present?}
  end

end

class SemAppsFilter

  attr_accessor :title, :tutors, :creator, :location, :semester

  def initialize(filter = {})
    @title    = filter[:title]         if filter[:title].present?
    @tutors   = filter[:tutors]        if filter[:tutors].present?
    @creator  = filter[:creator]       if filter[:creator].present?
    @location = filter[:location].to_i if filter[:location].present?
    @semester = filter[:semester].to_i if filter[:semester].present?
  end

  def scope
    scope = SemApp.scoped({})
    scope = scope.conditions "lower(sem_apps.title) LIKE ?", "%#{@title.downcase}%" unless @title.blank?
    scope = scope.conditions "lower(sem_apps.tutors) LIKE ?", "%#{@tutors.downcase}%" unless @tutors.blank?
    scope = scope.conditions "lower(users.name) LIKE ?", "%#{@creator.downcase}%" unless @creator.blank?
    scope = scope.conditions "location_id = ?", "#{@location}" unless @location.blank?
    scope = scope.conditions "semester_id = ?", "#{@semester}" unless @semester.blank?
    scope
  end

end

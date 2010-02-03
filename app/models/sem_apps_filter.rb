class SemAppsFilter

  attr_accessor :title, :tutors, :creator, :location

  def initialize(filter = {})
    self.title    = filter[:title]         if filter[:title].present?
    self.tutors   = filter[:tutors]        if filter[:tutors].present?
    self.creator  = filter[:creator]       if filter[:creator].present?
    #self.approved = filter[:approved]      if filter[:approved].present?
    self.location = filter[:location].to_i if filter[:location].present?
  end

  def scope
    scope = SemApp.scoped({})
    scope = scope.conditions "lower(title) LIKE ?", "%#{title.downcase}%" unless title.blank?
    scope = scope.conditions "lower(tutors) LIKE ?", "%#{tutors.downcase}%" unless tutors.blank?
    scope = scope.conditions "lower(users.name) LIKE ?", "%#{creator.downcase}%" unless creator.blank?
    #scope = scope.conditions "approved = ?", false unless approved
    scope = scope.conditions "location_id = ?", "#{location}" unless location.blank?
    #scope = scope.conditions "books.scheduled_for_addition = ? or books.scheduled_for_removal = ?", false, false
    #scope = scope.conditions "approved = ? OR marked = ? OR marked = ?", false, true, false unless approved
    scope
  end

end

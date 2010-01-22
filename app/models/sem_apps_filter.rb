class SemAppsFilter

  attr_accessor :title, :tutors, :creator, :approved

  def scope
    scope = SemApp.scoped({})
    scope = scope.conditions "lower(title) LIKE ?", "%#{title.downcase}%" unless title.blank?
    scope = scope.conditions "lower(tutors) LIKE ?", "%#{tutors.downcase}%" unless tutors.blank?
    scope = scope.conditions "lower(users.name) LIKE ?", "%#{creator.downcase}%" unless creator.blank?
    scope = scope.conditions "approved = false" unless approved
    scope
  end

end

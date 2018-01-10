class ApplicationSettings < ApplicationRecord
  acts_as_singleton

  def current_semester_id
    Semester.current.id
  end

  def current_semester_id=(value)
    if value.present?
      semester = Semester.find(value.to_i)
      semester.current = true
      semester.save!
    end
  end

end

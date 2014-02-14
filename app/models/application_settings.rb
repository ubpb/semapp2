class ApplicationSettings < ActiveRecord::Base
  acts_as_singleton

  belongs_to :transit_source_semester, class_name: 'Semester'
  belongs_to :transit_target_semester, class_name: 'Semester'

  belongs_to :current_semester, class_name: 'Semester'
  attr_accessor :current_semester_id

  validate :transit

  def transit_configured?
    transit_source_semester.present? && transit_target_semester.present?
  end

  protected

  def transit
    if transit_target_semester.present? && transit_source_semester.blank?
      errors.add(:transit_target_semester, 'Wählen Sie ein Quell-Semester')
    end

    if transit_source_semester.present? && transit_target_semester.blank?
      errors.add(:transit_source_semester, 'Wählen Sie ein Ziel-Semester')
    end

    if transit_source_semester.present? && transit_target_semester.present?
      if transit_target_semester.id.to_i <= transit_source_semester.id.to_i
        errors.add(:transit_target_semester, 'Das Ziel-Semester muss nach dem Quell-Semster stattfinden')
      end
    end
  end

end

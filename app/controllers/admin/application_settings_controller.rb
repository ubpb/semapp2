class Admin::ApplicationSettingsController < Admin::ApplicationController

  def index
    @settings = ApplicationSettings.instance
    @settings.current_semester_id = Semester.current.try(:id)
  end

  def update
    # Custom handling for current semester
    current_semester_id = params[:application_settings].delete(:current_semester_id)
    if current_semester_id.present?
      semester = Semester.find(current_semester_id)
      semester.current = true
      semester.save!
    end

    # Go on with the other settings
    @settings = ApplicationSettings.instance
    @settings.current_semester_id = Semester.current.try(:id)
    if @settings.update_attributes(params[:application_settings])
      redirect_to admin_application_settings_path
    else
      render :index
    end
  end

end

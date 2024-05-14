class Admin::ApplicationSettingsController < Admin::ApplicationController

  def index
    @settings = ApplicationSettings.instance
  end

  def update
    @settings = ApplicationSettings.instance

    if @settings.update(permitted_params)
      Rails.cache.clear
      flash[:success] = "Änderungen wurden gespeichert"
    else
      flash[:error] = "Es ist ein Fehler aufgetreten"
    end

    redirect_to admin_application_settings_path
  end

private

  def permitted_params
    params.require(:application_settings).permit(:current_semester_id, :restrict_download_of_files_restricted_by_copyright)
  end

end

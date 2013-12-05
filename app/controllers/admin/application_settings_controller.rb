class Admin::ApplicationSettingsController < Admin::ApplicationController

  def index
    @settings = ApplicationSettings.instance
  end

  def update
    @settings = ApplicationSettings.instance
    if @settings.update_attributes(params[:application_settings])
      redirect_to admin_application_settings_path
    else
      render :index
    end
  end

end

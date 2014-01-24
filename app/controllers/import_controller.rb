class ImportController < ApplicationController

  before_filter :load_sem_app

  def create
    if params[:import_file].present?
      SemAppImporter.new(@sem_app, params[:import_file].tempfile).import!
      flash[:success] = "Import erfolgreich abgeschlossen."
      redirect_to sem_app_path(@sem_app, anchor: 'media')
    else
      flash[:error] = "Bitte wählen Sie eine Import-Datei."
      redirect_to import_sem_app_path(@sem_app)
    end
  rescue
    flash[:error] = "Bei dem Import ist ein Fehler aufgetreten und konnte nicht durchgeführt werden. Die Archiv-Datei konnte nicht gelesen werden. Es können nur Archive importiert werden, die vorher mit den Seminarapparaten exportiert wurden."
    redirect_to sem_app_path(@sem_app, anchor: 'media')
  end

private

  def load_sem_app
    @sem_app = SemApp.find(params[:id])
    unauthorized! if cannot? :edit, @sem_app
  end

end

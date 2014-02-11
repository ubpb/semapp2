class ExportController < ApplicationController

  def export
    sem_app  = SemApp.find(params[:id])
    authorize! :edit, @sem_app

    exporter = SemAppExporter.new(sem_app)

    filename = "#{sem_app.semester.title.parameterize}-#{sem_app.title.parameterize[0..50]}.zip"
    zip      = exporter.export!
    send_file(zip, type: 'application/zip', filename: filename)
  end

end

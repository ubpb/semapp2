class ExportController < ApplicationController

  def export
    sem_app  = SemApp.find(params[:id])
    exporter = SemAppExporter.new(sem_app)

    filename = exporter.export!

    send_file(filename, type: 'application/zip', filename: "#{sem_app.title}.zip")
  end

end

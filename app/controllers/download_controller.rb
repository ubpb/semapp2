class DownloadController < ApplicationController

  def download
    attachment = FileAttachment.includes(:media => :sem_app).find(params[:id])

    authorize!(:download, attachment)

    sem_app = attachment.media.sem_app
    if sem_app.is_unlocked_in_session?(session) or can?(:edit, sem_app)
      file = attachment.file.path(params[:style])
      unless File.exist?(file)
        flash[:error] = 'Diese Datei existiert nicht'
        redirect_to sem_app_path(sem_app, :anchor => 'media')
      else
        send_file(file,
          :stream      => true,
          :filename    => attachment.file_file_name,
          :disposition => 'attachment',
          :type        => attachment.file_content_type || 'application/octed-stream'
        )
      end
    else
      flash[:error] = 'Zugriff verweigert'
      redirect_to sem_app_path(sem_app, :anchor => 'media')
    end
  end

end

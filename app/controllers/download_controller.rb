class DownloadController < ApplicationController

  def download
    attachment = FileAttachment.find(params[:id])

    sem_app = attachment.entry.sem_app
    if sem_app.is_unlocked_in_session?(session) or can?(:edit, sem_app)
      send_file(attachment.file.path(params[:style]),
        :stream      => true,
        :filename    => attachment.file_file_name,
        :disposition => 'attachment',
        :type        => attachment.file_content_type || 'application/octed-stream'
      )
    else
      flash[:error] = 'Zugriff verweigert'
      redirect_to sem_app_path(sem_app, :anchor => 'media')
    end
  end

end

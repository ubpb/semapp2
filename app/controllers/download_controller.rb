class DownloadController < ApplicationController

  def download
    attachment = Attachment.find(params[:id])

    sem_app = attachment.entry.sem_app
    if sem_app.is_unlocked_in_session?(session) or sem_app.is_editable_for?(current_user)
      send_file(attachment.attachable.path(params[:style]),
        :stream      => true,
        :filename    => attachment.attachable_file_name,
        :disposition => 'attachment',
        :type        => attachment.attachable_content_type || 'application/octed-stream'
      )
    else
      flash[:error] = 'Zugriff verweigert'
      redirect_to sem_app_path(sem_app, :anchor => 'media')
    end
  end

end

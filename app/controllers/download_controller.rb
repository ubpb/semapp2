class DownloadController < ApplicationController

  def download
    # load the attachment by the given id
    attachment = Attachment.find(params[:id])

    # check access
    sem_app = attachment.sem_app_entry.sem_app
    unless sem_app.is_unlocked_in_session?(session)
      flash[:error] = 'Zugriff verweigert'
      redirect_to sem_app_path(sem_app, :anchor => 'media')
      return false
    end

    # finally send the file
    send_file(attachment.attachable.path(params[:style]),
      :stream      => true,
      :filename    => attachment.attachable_file_name,
      :disposition => 'attachment',
      :type        => attachment.attachable_content_type || 'application/octed-stream'
    )
  end

end

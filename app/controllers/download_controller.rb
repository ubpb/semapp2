# encoding: utf-8

class DownloadController < ApplicationController

  def download
    attachment = FileAttachment.find(params[:id], :include => {:entry => [:sem_app]})

    sem_app = attachment.entry.sem_app
    if sem_app.is_unlocked_in_session?(session) or can?(:edit, sem_app)
      file = attachment.file.path(params[:style])
      unless File.exists?(file)
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

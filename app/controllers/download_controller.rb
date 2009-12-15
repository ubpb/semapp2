class DownloadController < ApplicationController

  def download
    # load the attachment by the given id
    entry = SemAppFileEntry.find(params[:id])

    # TODO: security check
    sem_app = entry.sem_app
    # ... check if the user is allowed to read files from this sem_app

    # check all relevant elements of the path to defend url guessing
    request_path = "#{params[:hash1]}/#{params[:hash2]}/#{params[:hash3]}/#{params[:id]}/#{params[:style]}"
    path = entry.attachment.path(params[:style])
    unless path.include?(request_path)
      render :file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404
      return false
    end

    # finally send the file
    send_file(path,
      :stream      => true,
      :filename    => entry.attachment_file_name,
      :disposition => 'attachment',
      :type        => entry.attachment_content_type || 'application/octed-stream')
  end

end

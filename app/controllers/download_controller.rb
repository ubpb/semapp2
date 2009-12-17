class DownloadController < ApplicationController

  def download
    # load the attachment by the given id
    attachment = Attachment.find(params[:id])

    # TODO: security check
    sem_app = attachment.sem_app_entry.sem_app
    # ... check if the user is allowed to read files from this sem_app

    # check all relevant elements of the path to defend url guessing
    #request_path = "#{params[:hash1]}/#{params[:hash2]}/#{params[:hash3]}/#{params[:id]}/#{params[:style]}"
    path = attachment.attachable.path(params[:style])
    #unless path.include?(request_path)
    #  render :file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404
    #  return false
    #end

    # finally send the file
    send_file(path,
      :stream      => true,
      :filename    => attachment.attachable_file_name,
      :disposition => 'attachment',
      :type        => attachment.attachable_content_type || 'application/octed-stream'
    )
  end

end

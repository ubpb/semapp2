class FileAttachmentsController < ApplicationController

  def new
    @media = find_media
    authorize! :edit, @media.sem_app

    @file_attachment = @media.file_attachments.build
  end

  def create
    @media = find_media
    authorize! :edit, @media.sem_app

    @file_attachment = @media.file_attachments.build(permitted_params)
    @file_attachment.creator = current_user

    if @file_attachment.save
      redirect_to sem_app_path(@media.sem_app, :anchor => 'media')
    else
      render :new
    end
  end

  def edit
    @file_attachment = FileAttachment.find(params[:id])
    authorize! :edit, @file_attachment.media.sem_app
  end

  def update
    @file_attachment = FileAttachment.find(params[:id])
    authorize! :edit, @file_attachment.media.sem_app

    if @file_attachment.update(permitted_params)
      redirect_to sem_app_path(@file_attachment.media.sem_app, :anchor => 'media')
    else
      render :edit
    end
  end

  def destroy
    @file_attachment = FileAttachment.find(params[:id])
    authorize! :edit, @file_attachment.media.sem_app

    unless @file_attachment.destroy
      flash[:error] = "Die Datei konnte nicht gelöscht werden. Es ist ein Fehler aufgetreten."
    end
    redirect_to sem_app_path(@file_attachment.media.sem_app, :anchor => 'media')
  end

private

  def find_media
    params.each do |name, value|
      if name =~ /(media_.+)_id$/
        media = $1.classify.constantize.find(value)
        return media
      end
    end
    nil
  end

  def permitted_params
    params.require(:file_attachment).permit(:file, :description, :restricted_by_copyright, :accepts_copyright)
  end

end

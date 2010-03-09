# encoding: utf-8

class FileAttachmentsController < ApplicationController

  def new
    @entry = find_entry
    unauthorized! if cannot? :edit, @entry.sem_app

    @file_attachment = @entry.file_attachments.build
  end

  def create
    @entry = find_entry
    unauthorized! if cannot? :edit, @entry.sem_app

    @file_attachment = @entry.file_attachments.build(params[:file_attachment])
    @file_attachment.creator = current_user

    if @file_attachment.save
      redirect_to sem_app_path(@entry.sem_app, :anchor => 'media')
    else
      render :new
    end
  end

  def edit
    @file_attachment = FileAttachment.find(params[:id])
    unauthorized! if cannot? :edit, @file_attachment.entry.sem_app
  end

  def update
    @file_attachment = FileAttachment.find(params[:id])
    unauthorized! if cannot? :edit, @file_attachment.entry.sem_app

    if @file_attachment.update_attributes(params[:file_attachment])
      redirect_to sem_app_path(@file_attachment.entry.sem_app, :anchor => 'media')
    else
      render :edit
    end
  end

  def destroy
    @file_attachment = FileAttachment.find(params[:id])
    unauthorized! if cannot? :edit, @file_attachment.entry.sem_app
    
    unless @file_attachment.destroy
      flash[:error] = "Die Datei konnte nicht gelöscht werden. Es ist ein Fehler aufgetreten."
    end
    redirect_to sem_app_path(@file_attachment.entry.sem_app, :anchor => 'media')
  end

  private

  def find_entry
    params.each do |name, value|
      if name =~ /(.+_entry)_id$/
        entry = $1.classify.constantize.find(value)
        return entry
      end
    end
    nil
  end

end
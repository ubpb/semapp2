class MediaController < ApplicationController

  def new
    @sem_app = SemApp.find(params[:sem_app_id])
    authorize! :edit, @sem_app

    respond_to do |format|
      format.js { render :partial => 'sem_apps/new_media_panel', :locals => {:sem_app => @sem_app, :origin_id => params[:origin_id], :scroll_to => params[:scroll_to]}, :layout => false }
    end
  end

  def reorder
    @sem_app = SemApp.includes(:media).find(params[:sem_app_id])
    authorize! :edit, @sem_app

    params[:media].each_with_index do |id, index|
      Media.where(id: id).update_all(position: index+1)
    end

    render body: nil
  end

end

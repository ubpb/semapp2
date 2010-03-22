# encoding: utf-8

class EntriesController < ApplicationController

  def new
    @sem_app = SemApp.find(params[:sem_app_id])
    unauthorized! if cannot? :edit, @sem_app

    respond_to do |format|
      format.js { render :partial => 'sem_apps/new_entry_panel', :locals => {:sem_app => @sem_app, :origin_id => params[:origin_id]}, :layout => false }
    end
  end

  def reorder
    @sem_app = SemApp.find(params[:sem_app_id])
    unauthorized! if cannot? :edit, @sem_app

    entries = params[:entry]
    if entries.present?
      entries.each_index do |i|
        id = params[:entry][i]
        Entry.find_by_id_and_sem_app_id!(id, @sem_app.id).update_attribute(:position, i+1) if id.present?
      end
    end

    #redirect_to sem_app_path(@sem_app, :anchor => 'media')
    render :nothing => true
  end
  
end

class SemAppEntriesController < ApplicationController

  def show
    @sem_app_entry = SemAppEntry.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def new
    sem_app         = SemApp.find(params[:sem_app_id])
    instance_type   = params[:instance_type].classify.constantize
    
    @buddy_entry_id = params[:buddy_entry_id]
    @sem_app_entry = SemAppEntry.new(:sem_app => sem_app, :instance => instance_type.new)
  end

  def create
    sem_app       = SemApp.find(params[:sem_app_id])
    instance_type = params[:instance_type].classify.constantize

    instance      = instance_type.new(params[instance_type.to_s.underscore.to_sym])
    @sem_app_entry = SemAppEntry.new(:sem_app => sem_app, :instance => instance)

    if (@sem_app_entry.save!)
      respond_to do |format|
        format.js
      end
    else
      render :action => 'new'
    end
  end

  def edit
    @sem_app_entry = SemAppEntry.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    @sem_app_entry = SemAppEntry.find(params[:id])
    type  = @sem_app_entry.instance_type.underscore
    @sem_app_entry.instance.update_attributes(params[type.to_sym])

    respond_to do |format|
      if @sem_app_entry and @sem_app_entry.instance.save
        format.js
      else
        format.js { render :action => 'edit' }
      end
    end
  end

  def destroy
    SemAppEntry.transaction do
      entry = SemAppEntry.find(params[:id])
      if (entry.instance.class == SemAppBookEntry)
        entry.instance.update_attributes(:scheduled_for_removal => true)
      else
        entry.instance.destroy
        entry.destroy
        entry.remove_from_list
      end
    end
    render :nothing => true
  end

  #
  # reorder entries
  #
  def reorder
    entries = params[:sem_app_media_entries]
    if entries
      SemAppEntry.transaction do
        entries.each_index do |i|
          id = params[:sem_app_media_entries][i]
          if (id and !id.empty?)
            entry = SemAppEntry.find_by_id!(id)
            entry.position = i
            entry.save!
          end
        end
      end
    end
    render :nothing => true
  end

end

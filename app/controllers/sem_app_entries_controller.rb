class SemAppEntriesController < ApplicationController

  before_filter :require_user
  before_filter :load_sem_app
  before_filter :check_access

  def new
    instance_type = params[:instance_type].classify.constantize
    @sem_app_entry = SemAppEntry.new(:sem_app => @sem_app, :instance => instance_type.new)
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def create
    instance_class      = params[:instance_type].classify.constantize
    instance_attributes = params[instance_class.to_s.underscore.to_sym]
    instance            = instance_class.new()

    instance.attributes = instance_attributes
    @sem_app_entry = SemAppEntry.new(:sem_app => @sem_app, :instance => instance)

    respond_to do |format|
      if (instance.save and @sem_app_entry.save and @sem_app_entry.insert_at(1))
        format.js { render :layout => false, :content_type => 'text/html' }
      else
        format.js { render :action => :new, :layout => false, :status => 409, :content_type => 'text/html' }
      end
    end
  end

  def edit
    @sem_app_entry = SemAppEntry.find(params[:id])
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def update
    @sem_app_entry = SemAppEntry.find(params[:id])
    instance_type  = @sem_app_entry.instance_type.underscore
    @sem_app_entry.instance.update_attributes(params[instance_type.to_sym])

    respond_to do |format|
      if @sem_app_entry.instance.save and @sem_app_entry.save
        format.js { render :layout => false, :content_type => 'text/html' }
      else
        format.js { render :action => :edit, :layout => false, :status => 409, :content_type => 'text/html' }
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
        entry.resync_positions
      end
    end
    render :nothing => true
  end

  #
  # reorder entries
  #
  def reorder
    entries = params['sem-app-entry']
    if entries
      SemAppEntry.transaction do
        entries.each_index do |i|
          id = params['sem-app-entry'][i]
          if (id and !id.empty?)
            SemAppEntry.find_by_id!(id).update_attribute(:position, i+1)
          end
        end
      end
    end
    render :nothing => true
  end

  private

  def load_sem_app
    @sem_app = SemApp.find(params[:sem_app_id])
  end

  def check_access
    unless @sem_app.is_editable?
      flash[:error] = "Zugriff verweigert"
      redirect_to sem_app_path(@sem_app)
      return false
    end
  end

end

class EntriesController < ApplicationController

  def new
    @sem_app = SemApp.find(params[:sem_app_id])
    unauthorized! if cannot? :edit, @sem_app

    respond_to do |format|
      format.js { render :partial => 'sem_apps/new_entry_panel', :locals => {:sem_app => @sem_app, :origin_id => params[:origin_id]}, :layout => false }
    end
  end

  def reorder
    @sem_app = SemApp.includes(:entries).find(params[:sem_app_id])
    unauthorized! if cannot? :edit, @sem_app

    entries = params[:entry]
    sql     = "select reorder(#{@sem_app.id}, ARRAY[#{entries.join(',')}]);"
    Entry.connection.execute(sql)

    render :nothing => true
  end

end

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
    @sem_app = SemApp.find(params[:sem_app_id], :include => [:entries])
    unauthorized! if cannot? :edit, @sem_app

    Entry.transaction do
      entries    = params[:entry]
      db_entries = @sem_app.entries

      if db_entries.present?
        db_entries.each do |e|
          current_pos = e.position

          index   = entries.index(e.id.to_s).try(:to_i)
          new_pos = index.try(:+, 1)

          e.update_attribute(:position, new_pos) if new_pos.present? and new_pos != current_pos
        end
      end
    end

    render :nothing => true
  end
  
end

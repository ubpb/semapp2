class EntriesController < ApplicationController

  # TODO: Secure the controller

  def reorder
    @sem_app = SemApp.find(params[:sem_app_id])
    entries = params[:entry]
    if entries.present?
      entries.each_index do |i|
        id = params[:entry][i]
        Entry.find_by_id_and_sem_app_id!(id, @sem_app.id).update_attribute(:position, i+1) if id.present?
      end
    end

    redirect_to sem_app_path(@sem_app, :anchor => 'media')
  end
  
end

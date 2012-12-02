# encoding: utf-8

class AbstractEntriesController < ApplicationController

  # TODO: TMP-DEVISE-DEACTIVATION - reactivate this
  # before_filter :authenticate_user!

  cache_sweeper :entry_sweeper

  def new
    @sem_app = SemApp.find(params[:sem_app_id])
    unauthorized! if cannot? :edit, @sem_app

    @entry         = self.controller_class.new
    @entry.sem_app = @sem_app
    @origin_id     = params[:origin_id]
  end

  def create
    @sem_app = SemApp.find(params[:sem_app_id])
    unauthorized! if cannot? :edit, @sem_app

    @entry          = self.controller_class.new(params[self.controller_class.name.underscore.to_sym])
    @entry.sem_app  = @sem_app
    @entry.position = @sem_app.next_position(params[:origin_id])
    @entry.creator  = current_user

    if @entry.save
      redirect_to sem_app_path(@sem_app, :anchor => 'media')
    else
      render :new
    end
  end

  def edit
    @entry = self.controller_class.find(params[:id])
    unauthorized! if cannot? :edit, @entry.sem_app

    if not current_user.is_admin? and @entry.respond_to?(:scanjob) and @entry.scanjob.present?
      flash[:error] = "Für diesen Eintrag wurde ein Scan beauftragt, der noch nicht abgeschlossen ist. Solange der Scanauftrag durch die Bibliothek bearbeitet wird, kann der Eintrag nicht bearbeitet werden."
      redirect_to sem_app_path(@entry.sem_app, :anchor => 'media')
    end
  end

  def update
    @entry = self.controller_class.find(params[:id])
    unauthorized! if cannot? :edit, @entry.sem_app
    
    if @entry.update_attributes(params[self.controller_class.name.underscore.to_sym])
      redirect_to sem_app_path(@entry.sem_app, :anchor => 'media')
    else
      render :edit
    end
  end

  def destroy
    @entry = self.controller_class.find(params[:id])
    unauthorized! if cannot? :edit, @entry.sem_app

    if not current_user.is_admin? and @entry.respond_to?(:scanjob) and @entry.scanjob.present?
      flash[:error] = "Für diesen Eintrag wurde ein Scan beauftragt, der noch nicht abgeschlossen ist. Solange der Scanauftrag durch die Bibliothek bearbeitet wird, kann der Eintrag nicht gelöscht werden."
      redirect_to sem_app_path(@entry.sem_app, :anchor => 'media')
      return false
    end

    if @entry.destroy
      render :nothing => true
    else
      flash[:error] = "Der Eintrag konnte nicht gelöscht werden. Es ist ein Fehler aufgetreten."
      redirect_to sem_app_path(@entry.sem_app, :anchor => 'media')
    end
  end

  protected

  def self.controller_for(value)
    cattr_accessor :controller_class
    self.controller_class = value.to_s.classify.constantize
  end

end

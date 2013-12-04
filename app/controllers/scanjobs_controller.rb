class ScanjobsController < ApplicationController

  before_filter :load_entry

  def new
    unless @entry.sem_app.is_from_current_semester?
      flash[:error] = "Der Seminarapparat ist nicht aus dem aktuellen Semester. Sie können Scanaufträge nur für aktuelle Seminarapparate beauftragen."
      redirect_to sem_app_path(@entry.sem_app, :anchor => 'media')
    end

    @scanjob = @entry.build_scanjob

    # Inspect the entry
    if @entry.respond_to?(:pages_from)
      @scanjob.pages_from = @entry.pages_from
    end
    if @entry.respond_to?(:pages_to)
      @scanjob.pages_to = @entry.pages_to
    end
    if @entry.respond_to?(:signature)
      @scanjob.signature = @entry.signature
    end
    if @entry.respond_to?(:source_signature)
      @scanjob.signature = @entry.source_signature
    end
  end

  def create
    @scanjob = @entry.build_scanjob(params[:scanjob])
    @scanjob.creator = current_user

    if @scanjob.save
      flash[:success] = "Der Scan wurde beauftragt. Er wird in Kürze bereitgestellt."
      redirect_to sem_app_path(@entry.sem_app, :anchor => 'media')
    else
      render :new
    end
  end

  private


  def load_entry
    @entry = find_entry
    unauthorized! if cannot?(:edit, @entry.sem_app)

    if @entry.scanjob.present?
      flash[:error] = "Aktuell ist noch ein Scanauftrag anhängig. Sie können erst einen neuen Auftrag erstellen wenn dieser abgeschlossen wurde."
      redirect_to sem_app_path(@entry.sem_app, :anchor => 'media')
      return
    end
  end

  def find_entry
    params.each do |name, value|
      if name =~ /(.+_entry)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

end

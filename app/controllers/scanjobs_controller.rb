class ScanjobsController < ApplicationController

  before_filter :load_media

  def new
    unless @media.sem_app.is_from_current_semester?
      flash[:error] = "Der Seminarapparat ist nicht aus dem aktuellen Semester. Sie können Scanaufträge nur für aktuelle Seminarapparate beauftragen."
      redirect_to sem_app_path(@media.sem_app, :anchor => 'media')
    end

    @scanjob = @media.parent.build_scanjob

    # Inspect the media
    if @media.respond_to?(:pages_from)
      @scanjob.pages_from = @media.pages_from
    end
    if @media.respond_to?(:pages_to)
      @scanjob.pages_to = @media.pages_to
    end
    if @media.respond_to?(:signature)
      @scanjob.signature = @media.signature
    end
    if @media.respond_to?(:source_signature)
      @scanjob.signature = @media.source_signature
    end
  end

  def create
    @scanjob = @media.parent.build_scanjob(params[:scanjob])
    @scanjob.creator = current_user

    if @scanjob.save
      flash[:success] = "Der Scan wurde beauftragt. Er wird in Kürze bereitgestellt."
      redirect_to sem_app_path(@media.sem_app, :anchor => 'media')
    else
      render :new
    end
  end

  private


  def load_media
    @media = find_media
    authorize! :edit, @media.sem_app

    if @media.parent.scanjob.present?
      flash[:error] = "Aktuell ist noch ein Scanauftrag anhängig. Sie können erst einen neuen Auftrag erstellen wenn dieser abgeschlossen wurde."
      redirect_to sem_app_path(@media.sem_app, :anchor => 'media')
      return
    end
  end

  def find_media
    params.each do |name, value|
      if name =~ /(media_.+)_id$/
        return $1.classify.constantize.includes(:parent).find(value)
      end
    end
    nil
  end

end

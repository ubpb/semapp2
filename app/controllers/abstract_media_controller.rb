class AbstractMediaController < ApplicationController

  before_filter :require_authenticate

  def new
    @sem_app = SemApp.find(params[:sem_app_id])
    authorize! :edit, @sem_app

    @media         = model_class.new
    @origin_id     = params[:origin_id]
  end

  def create
    @sem_app = SemApp.find(params[:sem_app_id])
    authorize! :edit, @sem_app

    instance_params = params[model_class.name.underscore.to_sym]

    media            = Media.new
    media.sem_app    = @sem_app
    media.creator    = current_user
    media.position   = @sem_app.next_position(params[:origin_id])

    @media          = model_class.new(instance_params)
    @media.parent   = media

    if @media.save
      redirect_to sem_app_path(@sem_app, :anchor => 'media')
    else
      render :new
    end
  end

  def edit
    @media = model_class.includes(:parent => :sem_app).find(params[:id])
    authorize! :edit, @media.sem_app

    if not current_user.is_admin? and @media.respond_to?(:scanjob) and @media.scanjob.present?
      flash[:error] = "Für diesen Eintrag wurde ein Scan beauftragt, der noch nicht abgeschlossen ist. Solange der Scanauftrag durch die Bibliothek bearbeitet wird, kann der Eintrag nicht bearbeitet werden."
      redirect_to sem_app_path(@media.sem_app, :anchor => 'media')
    end
  end

  def update
    @media = model_class.includes(:parent => :sem_app).find(params[:id])
    authorize! :edit, @media.sem_app

    instance_params = params[model_class.name.underscore.to_sym]

    if @media.update_attributes(instance_params)
      redirect_to sem_app_path(@media.sem_app, :anchor => 'media')
    else
      render :edit
    end
  end

  def destroy
    @media = model_class.includes(:parent => :sem_app).find(params[:id])
    authorize! :edit, @media.sem_app

    if not current_user.is_admin? and @media.respond_to?(:scanjob) and @media.scanjob.present?
      flash[:error] = "Für diesen Eintrag wurde ein Scan beauftragt, der noch nicht abgeschlossen ist. Solange der Scanauftrag durch die Bibliothek bearbeitet wird, kann der Eintrag nicht gelöscht werden."
      redirect_to sem_app_path(@media.sem_app, :anchor => 'media')
      return false
    end

    if @media.destroy && @media.parent.destroy
      render :nothing => true
    else
      flash[:error] = "Der Eintrag konnte nicht gelöscht werden. Es ist ein Fehler aufgetreten."
      redirect_to sem_app_path(@media.sem_app, :anchor => 'media')
    end
  end

  protected

  def model_class
    self.controller_name.classify.constantize
  end

end

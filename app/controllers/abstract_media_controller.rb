class AbstractMediaController < ApplicationController

  before_action :authenticate!

  def new
    @sem_app = SemApp.find(params[:sem_app_id])
    authorize! :edit, @sem_app

    @media     = model_class.new
    @origin_id = params[:origin_id]
    @scroll_to = params[:scroll_to]
  end

  def create
    @sem_app = SemApp.find(params[:sem_app_id])
    authorize! :edit, @sem_app

    instance_type   = model_class.name.underscore.to_sym
    instance_params = permitted_instance_params(instance_type, params[instance_type])

    media              = Media.new
    media.sem_app      = @sem_app
    media.creator      = current_user
    media.position     = @sem_app.next_position(params[:origin_id])
    media.hidden       = instance_params.delete(:hidden) || false
    media.assign_attributes(extract_hidden_until_attributes_from(instance_params))

    @media          = model_class.new(instance_params)
    @media.parent   = media

    if @media.save
      flash[:scroll_to] = params.delete(:scroll_to)
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

    instance_type   = model_class.name.underscore.to_sym
    instance_params = permitted_instance_params(instance_type, params[instance_type])

    @media.parent.update_attributes(hidden: instance_params.delete(:hidden) || false)
    @media.parent.update_attributes(hidden_until: instance_params.delete(:hidden_until) || nil)
    @media.parent.update_attributes(extract_hidden_until_attributes_from(instance_params))

    if @media.update_attributes(instance_params)
      flash[:scroll_to] = params.delete(:scroll_to)
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
      render body: nil
    else
      flash[:error] = "Der Eintrag konnte nicht gelöscht werden. Es ist ein Fehler aufgetreten."
      redirect_to sem_app_path(@media.sem_app, :anchor => 'media')
    end
  end

  protected

  def model_class
    self.controller_name.classify.constantize
  end

  def permitted_instance_params(type, instance_params)
    case type
    when :media_headline
      instance_params.permit(:style, :headline, :hidden, "hidden_until(1i)", "hidden_until(2i)", "hidden_until(3i)", "hidden_until(4i)", "hidden_until(5i)")
    when :media_text
      instance_params.permit(:text, :hidden, :hidden_until)
    when :media_monograph
      instance_params.permit(:author, :title, :subtitle, :year, :place, :publisher, :edition, :isbn, :signature, :comment, :hidden, :hidden_until)
    when :media_article
      instance_params.permit(:author, :title, :journal, :volume, :year, :issue, :pages_from, :pages_to, :issn, :signature, :comment, :hidden, :hidden_until)
    when :media_collected_article
      instance_params.permit(:source_editor, :source_title, :source_subtitle, :source_year, :source_place, :source_publisher, :source_edition, :source_isbn, :source_signature, :author, :title, :pages_from, :pages_to, :comment, :hidden, :hidden_until)
    else
      instance_params
    end
  end

  def extract_hidden_until_attributes_from(params)
    {
      "hidden_until(1i)" => params.delete("hidden_until(1i)") || nil,
      "hidden_until(2i)" => params.delete("hidden_until(2i)") || nil,
      "hidden_until(3i)" => params.delete("hidden_until(3i)") || nil,
      "hidden_until(4i)" => params.delete("hidden_until(4i)") || nil,
      "hidden_until(5i)" => params.delete("hidden_until(5i)") || nil
    }
  end

end

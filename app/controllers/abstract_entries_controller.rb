class AbstractEntriesController < ApplicationController

  # TODO: Secure the controller
  # TODO: Ajaxify the controller

  def new
    @sem_app       = SemApp.find(params[:sem_app_id])
    @entry         = self.controller_class.new
    @entry.sem_app = @sem_app
    @origin_id     = params[:origin_id]
  end

  def create
    @sem_app        = SemApp.find(params[:sem_app_id])
    @entry          = self.controller_class.new(params[self.controller_class.name.underscore.to_sym])
    @entry.sem_app  = @sem_app
    @entry.position = get_position(params[:origin_id])
    @entry.creator  = current_user

    if @entry.save
      resync_positions(@sem_app)
      redirect_to sem_app_path(@sem_app, :anchor => 'media')
    else
      render :new
    end
  end

  def edit
    @entry = self.controller_class.find(params[:id])
    if @entry.respond_to?(:scanjob) and @entry.scanjob.present?
      flash[:error] = "Für diesen Eintrag wurde ein Scan beauftragt, der noch nicht abgeschlossen ist. Solange der Scanauftrag durch die Bibliothek bearbeitet wird, kann der Eintrag nicht bearbeitet werden."
      redirect_to sem_app_path(@entry.sem_app, :anchor => 'media')
    end
  end

  def update
    @entry = self.controller_class.find(params[:id])
    if @entry.update_attributes(params[self.controller_class.name.underscore.to_sym])
      redirect_to sem_app_path(@entry.sem_app, :anchor => 'media')
    else
      render :edit
    end
  end

  def destroy
    @entry = self.controller_class.find(params[:id])

    if @entry.respond_to?(:scanjob) and @entry.scanjob.present?
      flash[:error] = "Für diesen Eintrag wurde ein Scan beauftragt, der noch nicht abgeschlossen ist. Solange der Scanauftrag durch die Bibliothek bearbeitet wird, kann der Eintrag nicht gelöscht werden."
      redirect_to sem_app_path(@entry.sem_app, :anchor => 'media')
      return false
    end

    if @entry.destroy
      resync_positions(@entry.sem_app)
      redirect_to sem_app_path(@entry.sem_app, :anchor => 'media')
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

  private

  def get_position(origin_id)
    position = 1000 # TODO: FIX THIS

    begin
      if origin_id.present?
        origin_entry = SemAppEntry.find(origin_id)
        position     = origin_entry.position + 1
      end
    rescue
      # nothing
    end

    return position
  end

  def resync_positions(sem_app)
    entries = Entry.for_sem_app(sem_app).ordered_by('position asc')
    if entries.present?
      entries.each_with_index { |entry, i| entry.update_attribute(:position, i+1) }
    end
  end

end
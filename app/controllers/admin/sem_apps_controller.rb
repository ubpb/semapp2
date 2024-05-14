class Admin::SemAppsController < Admin::ApplicationController

  SEM_APP_FILTER_NAME = 'admin_sem_app_filter_name_p'.freeze

  def index
    @filter   = SemAppsFilter.get_filter_from_session(session, SEM_APP_FILTER_NAME)
    @filtered = @filter.filtered?(except: [:unapproved, :book_jobs])

    @sem_apps = @filter.filtered
      .page(params[:page])
      .per_page(10)
      .reorder("sem_apps.created_at desc")
  end

  def filter
    SemAppsFilter.set_filter_in_session(session, params[:filter], SEM_APP_FILTER_NAME)
    redirect_to :action => :index
  end

  def show
    @sem_app = SemApp.find_by_id(params[:id])

    unless @sem_app.present?
      flash[:error] = "Dieser Apparat existiert nicht"
      redirect_to admin_sem_apps_path and return
    end

    @ordered_books  = Book.for_sem_app(@sem_app).ordered.ordered_by('signature asc')
    @removed_books  = Book.for_sem_app(@sem_app).removed.ordered_by('signature asc')
    @deferred_books = Book.for_sem_app(@sem_app).deferred.ordered_by('signature asc')

    respond_to do |format|
      format.html { render 'show',  :format => 'html' }
      format.print { render 'show', :format => 'print', :layout => 'print' }
    end
  end

  def edit
    @sem_app = SemApp.find(params[:id])
    @sem_app.build_book_shelf unless @sem_app.book_shelf.present?
    @sem_app.build_book_shelf_ref unless @sem_app.book_shelf_ref.present?
  end

  def update
    @sem_app = SemApp.find(params[:id])

    was_approved = @sem_app.approved

    if @sem_app.update(permitted_params)
      if (@sem_app.approved and not was_approved and @sem_app.creator.present? and @sem_app.creator.email.present?)
        Notifications.sem_app_activated_notification(@sem_app).deliver
      end
      flash[:success] = "Die Daten wurden erfolgreich gespeichert"
      redirect_to :action => :show
    else
      render :action => :edit
    end
  end

  def set_creator
    @sem_app = SemApp.find(params[:id])

    login     = params[:login].upcase
    alma_user = AlmaConnector.resolve_user(login)

    if alma_user
      user = User.find_by(ilsuserid: alma_user.primary_id)

      if user
        if @sem_app.update_attribute(:creator, user)
          flash[:success] = ActionController::Base.helpers.sanitize "Besitzer erfolgreich gesetzt. #{login} kann den Seminarapparat <i>#{@sem_app.title}</i> nun bearbeiten."
        else
          flash[:error] = "Fehler: Der Benutzer konnte nicht als Besitzer eingetragen werden."
        end
      else
        u = User.new(ilsuserid: alma_user.primary_id, login: login)

        if u.save(validate: false) and @sem_app.update_attribute(:creator, u)
          flash[:success] = ActionController::Base.helpers.sanitize "Der Benutzer '#{login}' existierte nicht, wurde aber angelegt. Name und E-Mail sind erst verfügbar wenn der Nutzer sich das erste mal anmeldet. #{login} kann den Seminarapparat <i>#{@sem_app.title}</i> nun bearbeiten."
        else
          flash[:error] = "Es ist ein unbekannter Fehler aufgetreten!"
        end
      end
    else
      flash[:error] = "Ein Nutzer mit der Bibliotheksausweisnummer #{login} existiert nicht."
    end

    redirect_to admin_sem_app_path(@sem_app, :anchor => 'users')
  end

  def destroy
    @sem_app = SemApp.find(params[:id])
    @sem_app.destroy
    flash[:success] = "Seminarpparat '#{@sem_app.title}' gelöscht."
    redirect_to :action => :index
  end

private

  def permitted_params
    params.require(:sem_app).permit(
      :approved,
      :semester_id,
      :title,
      :course_id,
      :tutors,
      :location_id,
      :shared_secret,
      book_shelf_attributes: [:slot_number, :ils_account, :_destroy, :id],
      book_shelf_ref_attributes: [:sem_app_ref_id],
    )
  end

end

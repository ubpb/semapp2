module OwnershipsConcern

protected

  def do_create
    sem_app = SemApp.find(params[:sem_app_id])
    authorize! :edit, sem_app

    login      = params[:login].upcase
    aleph_user = Aleph::Connector.new.resolve_user(login)

    if aleph_user
      user = User.find_by(ilsuserid: aleph_user.id)

      if user
        if sem_app.add_ownership(user)
          flash[:success] = "Nutzer hinzugefügt"
        else
          flash[:error] = "Nutzer konnte nicht hinzugefügt werden"
        end
      else
        u = User.new(ilsuserid: aleph_user.id, login: login)

        if u.save(validate: false) and sem_app.add_ownership(u)
          flash[:success] = ActionController::Base.helpers.sanitize "Der Nutzer '#{login}' existierte nicht, wurde aber angelegt. Name und E-Mail sind erst verfügbar wenn der Nutzer sich das erste mal anmeldet. #{login} kann den Seminarapparat <i>#{sem_app.title}</i> nun bearbeiten."
        else
          flash[:error] = "Es ist ein unbekannter Fehler aufgetreten!"
        end
      end
    else
      flash[:error] = "Ein Nutzer mit der Bibliotheksausweisnummer #{login} existiert nicht."
    end

    sem_app
  end

  def do_destroy
    os      = Ownership.find(params[:id])
    sem_app = os.sem_app
    authorize! :edit, sem_app

    if os.destroy
      flash[:success] = "Bearbeitungsrechte entzogen"
    else
      flash[:error] = "Bearbeitungsrechte konnten nicht entzogen werden"
    end

    sem_app
  end

end

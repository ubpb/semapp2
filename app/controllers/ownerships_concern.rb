module OwnershipsConcern

protected

  def do_create
    sem_app = SemApp.find(params[:sem_app_id])
    authorize! :edit, sem_app

    login      = params[:login].upcase
    aleph_user = Aleph::Connector.new.resolve_user(login)

    if aleph_user
      user = User.create_or_update_aleph_user!(login, aleph_user)

      if sem_app.add_ownership(user)
        flash[:success] = "#{user.name} (#{login}) kann den Seminarapparat <i>#{sem_app.title}</i> nun bearbeiten.".html_safe
      else
        flash[:error] = "Nutzer konnte nicht hinzugefügt werden"
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

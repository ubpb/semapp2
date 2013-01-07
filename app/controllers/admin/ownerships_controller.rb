# encoding: utf-8

class Admin::OwnershipsController < Admin::ApplicationController

  def create
    sem_app = SemApp.find(params[:sem_app_id])
    login   = params[:login]
    user    = User.find_by_login(login)

    if user
      if sem_app.add_ownership(user)
        flash[:success] = "Nutzer hinzugefügt"
      else
        flash[:error] = "Nutzer konnte nicht hinzugefügt werden"
      end
    else
      u = User.new(:login => login)
      if u.save(false) and sem_app.add_ownership(u)
        flash[:success] = ActionController::Base.helpers.sanitize "Der Benutzer '#{login}' existierte nicht, wurde aber angelegt. Name und E-Mail sind erst verfügbar wenn der Nutzer sich das erste mal anmeldet. #{login} kann den Seminarapparat <i>#{sem_app.title}</i> nun bearbeiten."
      else
        flash[:error] = "Es ist ein unbekannter Fehler aufgetreten!"
      end
    end

    redirect_to admin_sem_app_path(sem_app, :anchor => 'users')
  end

  def destroy
    os      = Ownership.find(params[:id])
    sem_app = os.sem_app

    if os.destroy
      flash[:success] = "Bearbeitungsrechte entzogen"
    else
      flash[:error] = "Bearbeitungsrechte konnten nicht entzogen werden"
    end
    
    redirect_to admin_sem_app_path(sem_app, :anchor => 'users')
  end

end

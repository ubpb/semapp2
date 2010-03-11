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
      flash[:error] = "Es konnte kein Benutzer mit der Kennung '#{login}' gefunden werden. Hat sich der Benutzer schon einmal angemeldet?"
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

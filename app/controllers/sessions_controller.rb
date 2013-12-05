class SessionsController < ApplicationController

  def new
  end

  def create
    user = authenticate(params[:session])
    if user
      session[:user_id] = user.id
      redirect_to root_url, notice: 'Sie wurden erfolgreich angemeldet.'
    else
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    #reset_session
    redirect_to root_url, notice: 'Sie wurden erfolgreich abgemeldet.'
  end

  protected

    def authenticate(attributes)
      if attributes["login"].upcase.starts_with?('PS') && User.find_by(login: attributes["login"]).nil?
        flash.now.alert = 'Anmeldung fehlgeschlagen. Sie müssen von einem Dozenten authorisiert werden.'
        nil
      else
        begin
          return User.authenticate(attributes)
        rescue Aleph::AuthenticationError
          flash.now.alert = 'Anmeldung fehlgeschlagen. Überprüfen Sie Login und Passwort.'
        rescue Aleph::UnsupportedAccountTypeError
          flash.now.alert = 'Anmeldung nicht möglich. Dei Anmeldung setzt einen A-Ausweis voraus.'
        rescue Aleph::AccountLockedError
          flash.now.alert = 'Ihr Konto wurde gesperrt. Bitte wenden Sie sich an die Bibliothek.'
        rescue Exception => e
          puts e.message
          puts e.backtrace
          flash.now[:error] = 'Anmeldung fehlgeschlagen. Überprüfen Sie Login und Passwort.'
        end
        nil
      end
    end

end

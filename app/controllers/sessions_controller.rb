# encoding: utf-8

class SessionsController < ApplicationController

  def new

  end

  def create
    #user = User.by_login(params[:login]) # by_email(params[:email])
    user = authenticate(params[:session])
    if user
      session[:user_id] = user.id
      redirect_to root_url, notice: 'Sie wurden erfolgreich angemeldet.'
    else
      #flash.now.alert = 'Anmeldung fehlgeschlagen. Überprüfen Sie Login und Passwort.'
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    #reset_session
    redirect_to root_url, notice: 'Sie wurden erfolgreich abgemeldet.'
  end

  protected

    # TODO: The following should go into the User model, but where do we put the error messages?

    def authenticate(attributes={})
      # TODO: test Aleph-authentication
      #return User.find( 156 ) # Lecturer "Max Mustermann"
      #return User.find( 1 )   # Admin "Rene"
      #return User.find( 2 )   # Admin "Seminarapparat"
      return if ( aleph_user = aleph_authenticate(attributes) ).nil?
      user = User.create_or_update_aleph_user!(aleph_user)
      if user # authentication successful
        #user.try(:on_successful_authentication, aleph_user) # TODO:
        user.add_authority(Authority::LECTURER_ROLE) if aleph_user.status.match(/^PA.+/)
        user
      else
        flash.now.alert = 'Anmeldung fehlgeschlagen. Überprüfen Sie Login und Passwort.'
        nil
      end
    end

    def aleph_authenticate(attributes={})
      aleph = Aleph::Connector.new
      if aleph_user = aleph.authenticate(attributes[:login], attributes[:password])
        #success!(resource)
        aleph_user
      else
        flash.now.alert = 'Anmeldung fehlgeschlagen. Überprüfen Sie Login und Passwort.'
        #fail!(:invalid)
        nil
      end
    rescue Aleph::AuthenticationError
      flash.now.alert = 'Anmeldung fehlgeschlagen. Überprüfen Sie Login und Passwort.'
      nil
      #fail!(:invalid)
    rescue Aleph::UnsupportedAccountTypeError
      flash.now.alert = 'Anmeldung nicht möglich. Dei Anmeldung setzt einen A-Ausweis voraus.'
      nil
      #fail!(:aleph_unsupported)
    rescue Aleph::AccountLockedError
      flash.now.alert = 'Ihr Konto wurde gesperrt. Bitte wenden Sie sich an die Bibliothek.'
      nil
      #fail!(:aleph_account_locked)
    rescue Exception => e
      puts e.message
      puts e.backtrace
      flash.now[:error] = 'Anmeldung fehlgeschlagen. Überprüfen Sie Login und Passwort.'
      nil
      #fail!(:invalid)
    end

end

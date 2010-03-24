# encoding: utf-8

class Notifications < ActionMailer::Base

  def sem_app_activated_notification(user, sem_app)
    if user.present? and user.email.present? and sem_app.present?
      recipients user.email
      from       "information@ub.uni-paderborn.de"
      subject    "[Seminarapparate] Ihr Seminarapparat (#{sem_app.title}) wurde aktiviert"
      body       :user => user, :sem_app => sem_app
    end
  end

end

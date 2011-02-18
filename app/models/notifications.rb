# encoding: utf-8

class Notifications < ActionMailer::Base

  def sem_app_created_notification(sem_app)
    recipients sem_app.creator.email
    from       "information@ub.uni-paderborn.de"
    subject    "[Seminarapparate] Ihr Seminarapparat (#{sem_app.title}) wurde beantragt"
    body        :sem_app => sem_app
  end

  def sem_app_activated_notification(sem_app)
    recipients sem_app.creator.email
    from       "information@ub.uni-paderborn.de"
    subject    "[Seminarapparate] Ihr Seminarapparat (#{sem_app.title}) wurde aktiviert"
    body        :sem_app => sem_app
  end

  def sem_app_transit_notification(user, sem_apps)
    recipients user.email
    from       "information@ub.uni-paderborn.de"
    subject    "[Seminarapparate] Ihre Seminarapparate"
    body        :user => user, :sem_apps => sem_apps
  end

end

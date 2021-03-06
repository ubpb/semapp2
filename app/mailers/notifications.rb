class Notifications < ActionMailer::Base
  default from: "information@ub.uni-paderborn.de"
  layout "mailer"

  def sem_app_created_notification(sem_app)
    @sem_app = sem_app
    mail to:       sem_app.creator.email,
         subject:  "[Seminarapparate] Ihr Seminarapparat (#{sem_app.title}) wurde beantragt"
  end

  def sem_app_activated_notification(sem_app)
    @sem_app = sem_app
    mail to:       sem_app.creator.email,
         subject:  "[Seminarapparate] Ihr Seminarapparat (#{sem_app.title}) wurde aktiviert"
  end

  def sem_app_transit_notification(user, sem_apps)
    @user, @sem_apps = user, sem_apps
    mail to:       user.email,
         subject:  "[Seminarapparate] Ihre Seminarapparate"
  end

  def admin_mailing(user, subject, text, from = nil)
    @user = user
    @text = text
    mail(
      to: user.email,
      from: from.presence || Notifications.default[:from],
      subject: "[Seminarapparate] #{subject}"
    )
  end

end

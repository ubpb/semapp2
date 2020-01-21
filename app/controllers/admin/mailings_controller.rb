class Admin::MailingsController < Admin::ApplicationController

  def new
    @semesters = Semester.all
  end

  def create
    semester_ids = params[:message][:semesters]
    subject      = params[:message][:subject]
    text         = params[:message][:text]
    from         = params[:message][:from]
    users        = users(semester_ids)

    if users.blank?
      flash.now[:error] = "Keine Nutzer gefunden. Bitte wählen Sie min. ein Semester."
      render :new
    elsif subject.blank?
      flash.now[:error] = "Bitte geben Sie ein Betreff ein."
      render :new
    elsif text.blank?
      flash.now[:error] = "Bitte geben Sie einen Text ein."
      render :new
    else
      users[0..0].each do |user|
        clean_text = text.gsub(/\r\n/, "\n")
        Notifications.admin_mailing(user, subject, clean_text, from).deliver
      end
      flash[:success] = "Nachricht wurde versendet"
      redirect_to action: :new
    end
  end

protected

  def users(semester_ids)
    semester_ids = semester_ids.map(&:presence).compact
    sem_apps = SemApp.includes(:creator, :owners).where(semester_id: semester_ids)

    # Collect all users
    users = []
    sem_apps.each do |s|
      users << s.creator
      users  = users + s.owners
    end
    # Make sure every user gets only one mail
    users = users.uniq
    # Cleanup users that don't have a email address
    users = users.select{ |u| u.email.present? }
    # return users
    users
  end

end

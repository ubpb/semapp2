class SemAppTransitsController < ApplicationController

  def new
    @sem_app = SemApp.find(params[:sem_app_id])
    check_can_transit or return
  end

  def create
    @sem_app = SemApp.find(params[:sem_app_id])
    check_can_transit or return

    exclude_book_ids = @sem_app.book_ids - (params[:books] || []).map(&:to_i)

    transit_service = SemAppTransit.new(@sem_app, Semester.transit_target, exclude_book_ids: exclude_book_ids)
    target_sem_app = transit_service.transit!

    flash[:success] = """
      <p>Ihr Seminarapparat wurde erfolgreich übernommen. Wir prüfen die Angaben und schalten
      den Seminarapparat nach erfolgter Prüfung für Sie frei. Sie sehen den Status unter
      <strong>Meine Seminarapparate</strong>. Bis zur Freischaltung können nur Sie den Seminarapparat
      sehen und bearbeiten.</p>
      <p>Bitte überprüfen bzw. bearbeiten Sie unter 'Einstellungen' die Bearbeitungsrechte.</p>
    """.html_safe
    redirect_to sem_app_path(target_sem_app)
  end

private

  def check_can_transit
    unless @sem_app.can_transit?
      flash[:error] = "Übernahme nicht möglich. Bitte wenden Sie sich an das Informationszentrum der Bibliothek."
      redirect_to sem_app_path(@sem_app) and return
    end

    return true
  end

end

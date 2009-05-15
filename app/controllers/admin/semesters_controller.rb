class Admin::SemestersController < Admin::ApplicationController

  before_filter :setup_breadcrumb_for_all_actions
  
  def index
    @semesters = Semester.find(:all, :order => 'created_at DESC')
  end

  def new
    @semester = Semester.new
    setup_breadcrumb_for_new_and_create
  end

  def create
    @semester = Semester.new(params[:semester])
    setup_breadcrumb_for_new_and_create

    if (@semester.save)
      flash[:success] = "Semester erfolgreich erstellt"
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @semester = Semester.find(params[:id])
    setup_breadcrumb_for_edit_and_update(@semester)
  end

  def update
    @semester = Semester.find(params[:id])
    setup_breadcrumb_for_edit_and_update(@semester)

    @semester.update_attributes(params[:semester])
      
    if @semester.save
      flash[:success] = "Semester erfolgreich aktualisiert"
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def destroy
    semester = Semester.find(params[:id])
    if semester and semester.destroy
      flash[:success] = "Semester '#{semester.title}' erfolgreich gelöscht"
      redirect_to :action => 'index'
    else
      flash[:error] = "Semester konnte nicht gelöscht werden"
      redirect_to :action => 'index'
    end
  end

  private

  def setup_breadcrumb_for_all_actions
    pui_append_to_breadcrumb("Semester verwalten", admin_semesters_url)
  end

  def setup_breadcrumb_for_new_and_create
    pui_append_to_breadcrumb("Neues Semester anlegen", new_admin_semester_url)
  end

  def setup_breadcrumb_for_edit_and_update(semester)
    pui_append_to_breadcrumb("Semester bearbeiten", edit_admin_semester_url(semester))
  end

end

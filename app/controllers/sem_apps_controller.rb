class SemAppsController < ApplicationController

  before_filter :require_user, :only => [:create]

  def index
    # filter conditions
    conditions = ["", {}]

    # only approved and active sem apps
    add_condition(conditions, "AND", "approved = :approved", {:approved => true})
    add_condition(conditions, "AND", "active = :active", {:active => true})

    # try to filter by semester
#    if params[:semester]
#      @semester = Semester.find(params[:semester])
#      conditions = ["semester_id = :semester_id", {:semester_id => @semester.id}]
#    end
#
#    # try to filter by filter term
#    if params[:filter] and not params[:filter].empty?
#      @filter = params[:filter]
#      add_condition(conditions, "title like :title", {:title => @filter + "%"})
#    end

    # find sem apps
    @sem_apps = SemApp.paginate(
      :page => params[:page],
      :per_page => 30,
      :conditions => conditions,
      :order => 'semester_id, id DESC')
  end


  def show
    @sem_app = SemApp.find(params[:id])
  end


  def new
    pui_append_to_breadcrumb("Einen neuen eSeminarapparat beantragen", new_sem_app_path)
    @sem_app = SemApp.new
  end


  def create
    @sem_app = SemApp.new(params[:sem_app])
    if @sem_app.save and @sem_app.add_ownership(current_user)
      flash[:notice] = "Ihr eSeminarapparat wurde erfolgreich beantragt. Wir prüfen die Angaben und schalten
        den eSeminarappat nach erfolgter Prüfung frei. Sie sehen den Status auf Ihrer Konto Seite unter
        <strong>Meine eSeminarapparate</strong>."
      redirect_to user_path(:anchor => 'apps')
    else
      render :action => :new
    end
  end


  private

  
  def add_condition(conditions, operand, condition_str, values)
    if conditions[0].empty?
      conditions[0] = conditions[0].concat(condition_str)
    else
      conditions[0] = conditions[0].concat(" #{operand || 'AND'} " + condition_str)
    end
    conditions[1] = conditions[1].merge(values)
  end
  
end

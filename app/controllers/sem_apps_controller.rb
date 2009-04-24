class SemAppsController < ApplicationController

  #
  # Displays a list of sem apps defined by the
  # given filter
  #
  def index
    # filter conditions
    conditions = ["", {}]

    # try to filter by semester
    if params[:semester]
      @semester = Semester.find_by_permalink!(params[:semester])
      conditions = ["semester_id = :semester_id", {:semester_id => @semester.id}]
    end

    # try to filter by filter term
    if params[:filter] and not params[:filter].empty?
      @filter = params[:filter]
      add_condition(conditions, "title like :title", {:title => @filter + "%"})
    end

    # find sem apps
    @sem_apps = SemApp.paginate(
      :page => params[:page],
      :per_page => 30,
      :conditions => conditions,
      :order => 'semester_id, id DESC')
  end

  #
  # Shows a single sem app.
  #
  def show
    @sem_app = SemApp.find(params[:id])
  end

  private

  def add_condition(conditions, condition_str, values)
    if conditions[0].empty?
      conditions[0] = conditions[0].concat(condition_str)
    else
      conditions[0] = conditions[0].concat(" AND " + condition_str)
    end
    conditions[1] = conditions[1].merge(values)
  end
  
end

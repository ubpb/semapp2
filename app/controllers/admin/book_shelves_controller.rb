class Admin::BookShelvesController < Admin::ApplicationController

  def index
    if params[:filter].present? and params[:filter][:location].present?
      location_id = params[:filter][:location]

      if location_id.present?
        @shelves = BookShelf
          .joins(:sem_app => :location)
          .where("sem_apps.location_id = :location_id AND sem_apps.semester_id = :semester_id",
            location_id: location_id,
            semester_id: Semester.current.id
          )
          .to_a

        @shelves.sort!{|x, y| x.slot_number.to_i <=> y.slot_number.to_i }
      end
    end
  end

end

# encoding: utf-8

class Admin::BookShelvesController < Admin::ApplicationController

  def index
    if params[:filter].present? and params[:filter][:location].present?
      location = params[:filter][:location]
      if location.present? and location.to_i.to_s.present?
        @shelves = BookShelf.find(:all,
          :conditions => "sem_apps.location_id = #{location} AND sem_apps.semester_id = #{Semester.current.id}",
          :include => {:sem_app => [:location]})
        @shelves.sort! {|x, y| x.slot_number.to_i <=> y.slot_number.to_i }
      end
    end
  end

end
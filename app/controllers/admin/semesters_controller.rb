class Admin::SemestersController < Admin::ApplicationController

  def index
    @semesters = Semester.find(:all)
  end

end

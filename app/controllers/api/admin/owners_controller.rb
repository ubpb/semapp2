class Api::Admin::OwnersController < Api::Admin::ApplicationController

  def index
    owners = SemApp.includes(:creator).order("creator_id").map{|s| s.creator.attributes}.uniq

    owners = owners.map do |owner|
      newest_edit = SemApp.where(creator_id: owner["id"]).order("updated_at desc").pluck("updated_at").first
      owner["newest_edit"] = newest_edit.strftime("%Y-%m-%d")
      owner
    end

    render json: owners
  end

end

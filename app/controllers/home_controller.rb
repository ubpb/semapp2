# encoding: utf-8

class HomeController < ApplicationController

  def index
    redirect_to semester_index_path
  end

end

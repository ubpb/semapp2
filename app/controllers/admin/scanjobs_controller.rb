# encoding: utf-8

require 'barby'
require 'barby/outputter/png_outputter'

class Admin::ScanjobsController < Admin::ApplicationController

  def index
    @ordered_scanjobs  = Scanjob.ordered.ordered_by('created_at')
    @accepted_scanjobs = Scanjob.accepted.ordered_by('created_at')
    @rejected_scanjobs = Scanjob.rejected.ordered_by('created_at')
    @deferred_scanjobs = Scanjob.deferred.ordered_by('created_at')

    respond_to do |format|
      format.html  { render 'index', :format => 'html' }
      format.print { render 'index', :format => 'print', :layout => 'print' }
    end
  end

  def show
    @scanjob = Scanjob.find(params[:id])
  end

  #
  # Renders a single scanjob in print layout
  #
  def print_job
    @scanjob = Scanjob.find(params[:id])
    update_scanjob_state(@scanjob)

    render :template => 'admin/scanjobs/print_job', :layout => 'print'
  end

  #
  # Renders a list of scanjobs in print layout
  #
  def print_list
    list_name = params[:list_name]
    lists = ['ordered', 'accepted', 'rejected', 'deferred']

    if lists.index(list_name)
      @scanjobs = Scanjob.send(list_name.to_sym).ordered_by('created_at')
      update_scanjobs_state(@scanjobs)
    end

    render :template => 'admin/scanjobs/print_list', :layout => 'print'
  end
  
  def barcode
    scanjob = Scanjob.find(params[:id])
    code = scanjob.code
    barcode = Barby::Code128B.new(code)
    send_data barcode.to_png(:height => 120, :xdim => 2), :filename => "#{code}.png", :disposition => 'inline'
  end

  def defer
    scanjob = Scanjob.find(params[:id])
    old_state = scanjob.state
    unless scanjob.set_state(:deferred)
      flash[:error] = "Es ist ein Fehler aufgetreten."
    end

    redirect_to admin_scanjobs_path(:anchor => old_state)
  end

  def dedefer
    scanjob = Scanjob.find(params[:id])
    old_state = scanjob.state
    unless scanjob.set_state(:accepted)
      flash[:error] = "Es ist ein Fehler aufgetreten."
    end

    redirect_to admin_scanjobs_path(:anchor => old_state)
  end

  private

  def update_scanjobs_state(scanjobs)
    scanjobs.each { |sj| update_scanjob_state(sj) }
  end

  def update_scanjob_state(scanjob)
    current_state = scanjob.state
    if current_state == 'ordered'
      scanjob.set_state(:accepted)
    end
  end

end
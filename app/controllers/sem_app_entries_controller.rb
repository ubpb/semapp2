class SemAppEntriesController < ApplicationController

  before_filter :require_user
  before_filter :load_sem_app
  before_filter :check_access

  def new
    entry_class = params[:class].classify.constantize
    entry       = entry_class.new
    raise "unknown instance" unless entry.kind_of?(SemAppEntry)
    
    # The origin_id is the id of the entry that the user
    # wants to create the new entry below
    @origin_id = params[:origin_id]

    respond_to do |format|
      format.json do
        render_json_response(:success, :partial => partial_path_for_entry_form(entry), :locals => {:entry => entry})
      end
    end
  end

  def create
    # prepare the new entry
    entry_class    = params[:class].classify.constantize
    attributes     = params[entry_class.name.underscore.to_sym]
    entry          = entry_class.new(attributes)
    raise "unknown instance" unless entry.kind_of?(SemAppEntry)
    entry.sem_app  = @sem_app

    # set the correct position for the new entry
    # below the entry with the given origin_id
    position    = 1
    @origin_id  = params[:origin_id]
    if @origin_id.present?
      origin_entry = SemAppEntry.find(@origin_id)
      position     = origin_entry.position + 1
    end
    entry.position = position
    
    # finally save the entry
    SemAppEntry.transaction do
      respond_to do |format|
        if (entry.valid? and entry.insert_at(position) and resync_positions)
          format.json do
            render_json_response(:success, :type => :create, :partial => 'sem_apps/entry', :locals => {:entry => entry})
          end
        else
          format.json do
            render_json_response(:error, :message => entry.errors.full_messages.to_sentence, :partial => partial_path_for_entry_form(entry), :locals => {:entry => entry})
          end
        end
      end
    end
  end

  def edit
    entry = SemAppEntry.find(params[:id])

    respond_to do |format|
      format.json do
        render_json_response(:success, :partial => partial_path_for_entry_form(entry), :locals => {:entry => entry})
      end
    end
  end

  def update
    entry         = SemAppEntry.find(params[:id])
    instance_type = entry.class.name.underscore.to_sym
    
    respond_to do |format|
      if entry.update_attributes(params[instance_type]) and entry.reload
        format.json do
          render_json_response(:success, :partial => partial_path_for_entry(entry), :locals => {:entry => entry})
        end
      else
        format.json do
          render_json_response(:error, :message => entry.errors.full_messages.to_sentence, :partial => partial_path_for_entry_form(entry), :locals => {:entry => entry})
        end
      end
    end
  end

  def destroy
    SemAppEntry.transaction do
      entry = SemAppEntry.find(params[:id])
      entry.remove_from_list
      entry.destroy
      resync_positions
    end
    render :nothing => true
  end

  #
  # reorder entries
  #
  def reorder
    entries = params[:entry]
    if entries
      SemAppEntry.transaction do
        entries.each_index do |i|
          id = params[:entry][i]
          if (id and !id.empty?)
            SemAppEntry.find_by_id!(id).update_attribute(:position, i+1)
          end
        end
      end
    end
    render :nothing => true
  end

  private

  def load_sem_app
    @sem_app = SemApp.find(params[:sem_app_id])
  end

  def check_access
    unless @sem_app.is_editable_for?(current_user)
      flash[:error] = "Zugriff verweigert"
      redirect_to sem_app_path(@sem_app)
      return false
    end
  end

  def render_json_response(result, options = {})
    json = {}
    json[:result]  = result.to_s
    json[:message] = options[:message]
    json[:type]    = options[:type] if options[:type].present?

    if options[:partial].present?
      json[:partial] = render_to_string(:partial => options[:partial], :locals => options[:locals])
    end

    render :json => json, :content_type => 'text/plain'
  end

  def resync_positions
    entries = SemAppEntry.find(
      :all,
      :order      => :position,
      :conditions => ["sem_app_id = :sem_app_id", {:sem_app_id => @sem_app.id}]
    )
    
    if entries.present?
      SemAppEntry.transaction do
        entries.each_with_index { |o,i| o.update_attribute(:position, i+1) }
      end
    end
  end

end

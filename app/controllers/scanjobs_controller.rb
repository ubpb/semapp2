class ScanjobsController < ApplicationController

  # TODO: Secure the controller

  def new
    @entry = find_entry
    @scanjob= @entry.build_scanjob

    # Inspect the entry
    if @entry.respond_to?(:pages)
      @scanjob.pages = @entry.pages
    end
    if @entry.respond_to?(:signature)
      @scanjob.signature = @entry.signature
    end
    if @entry.respond_to?(:source_signature)
      @scanjob.signature = @entry.source_signature
    end
  end

  def create
    @entry = find_entry
    @scanjob = @entry.build_scanjob(params[:scanjob])
    @scanjob.creator = current_user

    if @scanjob.save
      flash[:success] = "Der Scan wurde beauftragt. Er wird in Kürze bereitgestellt."
      redirect_to sem_app_path(@entry.sem_app, :anchor => 'media')
    else
      render :new
    end
  end

  private

  def find_entry
    params.each do |name, value|
      if name =~ /(.+_entry)_id$/
        entry = $1.classify.constantize.find(value)
        return entry
      end
    end
    nil
  end

end
class Admin::AttachmentChecksController < Admin::ApplicationController

  def index
    @file_attachments = FileAttachment
      .joins(:media => :sem_app)
      .where(restricted_by_copyright: false)
      .order("updated_at desc")
      .page(params[:page])
      .per_page(20)
  end

end

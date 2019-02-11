module MediaSupport
  extend ActiveSupport::Concern

  module ClassMethods
    def acts_as_media_parent
      self.class_eval do
        belongs_to :instance,      -> { includes :parent }, polymorphic: true, dependent: :destroy, touch: true
        validates  :instance_id,   presence: true
        validates  :instance_type, presence: true
      end
    end

    def acts_as_media_instance
      self.class_eval do
        has_one  :parent,           -> { includes :file_attachments, :scanjob }, as: :instance, class_name: 'Media'
        delegate :position,          to: :parent, allow_nil: true
        delegate :hidden,            to: :parent, allow_nil: true
        delegate :hidden_until,      to: :parent, allow_nil: true
        delegate :currently_hidden?, to: :parent, allow_nil: true
        delegate :sem_app,           to: :parent, allow_nil: true
        delegate :file_attachments,  to: :parent, allow_nil: true
        delegate :scanjob,           to: :parent, allow_nil: true
      end
    end
  end
end

ActiveRecord::Base.send :include, MediaSupport

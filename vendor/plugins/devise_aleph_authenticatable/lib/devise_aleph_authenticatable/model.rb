# encoding: utf-8

require 'devise/models'
require 'devise_aleph_authenticatable/strategy'

module Devise #:nodoc:
  module Models #:nodoc:
    module AlephAuthenticatable

      def self.included(base) #:nodoc:
        base.class_eval do
          extend ClassMethods
          extend ::Devise::Models::SessionSerializer

          attr_accessor :password
        end
      end

      def on_successfull_authentication(aleph_user)
        # may be overridden in the app
      end

      module ClassMethods

        def authenticate(attributes={})
          aleph = Aleph::Connector.new
          aleph_user = aleph.authenticate(attributes[:login].upcase, attributes[:password])
          user = create_or_update_aleph_user!(attributes[:login].upcase, aleph_user)
          user.try(:on_successfull_authentication, aleph_user)
          return user
        end

        protected

        def create_or_update_aleph_user!(login, aleph_user)
          user = self.find_by_login(login)
          user.present? ? update_user!(user, aleph_user) : create_user!(aleph_user)
        end

        def create_user!(aleph_user)
          User.create!({:login => aleph_user.user_id, :name => aleph_user.name, :email => aleph_user.email})
        end

        def update_user!(user, aleph_user)
          user.update_attributes!({:name => aleph_user.name, :email => aleph_user.email})
          return user
        end
        
      end
    end
  end
end
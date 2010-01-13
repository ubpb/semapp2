# encoding: utf-8

require 'devise/strategies/base'

module Devise #:nodoc:
  module Strategies #:nodoc:

    # Default strategy for signing in a user using Aleph.
    # Redirects to sign_in page if it's not authenticated
    #
    class AlephAuthenticatable < ::Warden::Strategies::Base

      include ::Devise::Strategies::Base

      def valid?
        super && params[scope] && params[scope][:password].present?
      end

      # Authenticate user with Facebook Connect.
      #
      def authenticate!
        if resource = mapping.to.authenticate(params[scope])
          success!(resource)
        else
          fail!(:invalid)
        end
      end

    end

  end
end

Warden::Strategies.add(:aleph_authenticatable, ::Devise::Strategies::AlephAuthenticatable)
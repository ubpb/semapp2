class Api::Admin::ApplicationController < Api::ApplicationController
  if ENV['ADMIN_API_USERNAME'].present? && ENV['ADMIN_API_PASSWORD'].present?
    http_basic_authenticate_with name: ENV['ADMIN_API_USERNAME'], password: ENV['ADMIN_API_PASSWORD']
  end
end

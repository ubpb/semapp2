=begin
if Rails.env.development?
  ActionMailer::Base.smtp_settings = {
      address:              "smtp.gmail.com",
      port:                 587,
      domain:               "",
      user_name:            "",
      password:             "",
      authentication:       "plain",
      enable_starttls_auto: true
  }
  ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor)
end
=end

#ActionMailer::Base.default_url_options[:host] = "localhost:3000"
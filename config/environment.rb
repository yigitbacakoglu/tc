# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Omrats::Application.initialize!

ActionMailer::Base.smtp_settings = {
    :address => "smtp.yandex.ru",
    :port => 587,
    :user_name => "no-reply@talkycloud.com",
    :password => Secret.mail_secret,
    :authentication => :plain,
    :enable_starttls_auto => true,
    :host => "heroku.com"

}

Omrats::Application.configure do
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = true

end

#ActionMailer::Base.delivery_method = :smtp

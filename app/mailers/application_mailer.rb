class ApplicationMailer < ActionMailer::Base
  default from: -> { ENV.fetch("MAILER_SENDER", "reply@setlist.local") }
  layout "mailer"
end

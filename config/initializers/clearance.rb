Clearance.configure do |config|
  config.user_model = "Player"
  config.mailer_sender = ENV.fetch("MAILER_SENDER") { ENV.fetch("MAIL_FROM", "reply@setlist.local") }
  config.allow_sign_up = false
  config.routes = false
  config.cookie_expiration = ->(_cookies) { 30.days.from_now.utc }
end

# Force synchronous mail delivery for password resets
module Clearance
  class PasswordMailer
    def change_password(user)
      @user = user
      mail(to: user.email, subject: "Change your password").deliver_now
    end
  end
end
